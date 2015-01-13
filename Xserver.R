
library(shiny)


datafile = "SFPD_Incidents_-_Current_Year__2014_.csv"
data <- read.csv(datafile)

##fix day of week order
data$DayOfWeek <- factor(data$DayOfWeek, levels= c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

##for simplicity keep only complete cases
data<-data[complete.cases(data),]

data$Date<-as.Date(as.character(data$Date), "%m/%d/%Y")

#had to be a little clever with the time , basically trick everything to think it is the same day.
        #data$Time<-as.POSIXct(paste("1970-01-01", as.character(data$Time)), format="%Y-%m-%d %H:%M")

##while the above works. I found the analysis looks easier just hacking out the hour....

        ##Alternate method is just to that the hh and convert to a number.
        ##this proved reliable and not too complicated.
        data$Time <- as.numeric(substring(as.character(data$Time),1,2))

##Keep data points inside plot
        data<-data[data$X> -122.470,]
        data<-data[data$Y> 37.735,]
        data<-data[data$Y< 37.81,]
        data<-data[data$X< -122.375,]


require(ggmap)
require(mapproj)

##Subset data by crime
## here focus on only top crimes
##make data smaller by restricting time to 8pm ($Time==20)
        PlotTheft <-data[data$Category=="LARCENY/THEFT"&data$Time==20, c("X","Y")]
        PlotVehicle<-data[data$Category=="VEHICLE THEFT"&data$Time==20, c("X","Y") ]
        PlotAssault<-data[data$Category=="ASSAULT"&data$Time==20, c("X","Y") ] 
        PlotVandalism<-data[data$Category=="VANDALISM"&data$Time==20, c("X","Y")] 

##get map data
        map <- get_map(source="google", maptype="roadmap", location = 'San Francisco', zoom = 13)
##generate map
        map1 <- ggmap(map) 

        
        X<-c(-122.4, -122.411)
        Y<-c(37.79,37.81)

        ttt<-cbind(X,Y)
        ttt<-as.data.frame(ttt)

        tttp<-ggplot(ttt, aes(ttt$X,ttt$Y))+geom_point()
        #map2<-map1 + geom_point(aes(x = tt$X, y = tt$Y), data=tt, alpha = 1, color="red", size = 4)

        #map2<-map1 + geom_point(aes(x = PlotTheft$X, y = PlotTheft$Y), data = PlotTheft, alpha = .1, color="red", size = 3)
        #map3<-map1 + geom_point(aes(x = PlotAssault$X, y = PlotAssault$Y), data = PlotAssault, alpha = .1, color="blue", size = 3)

#if (input$id2=="Assault") map2<-map2 + geom_point(aes(x = PlotVehicle$X, y = PlotVehicle$Y), data = PlotVehicle, alpha = .2, color="darkgreen", size = 3)

#map2<-map1


shinyServer(
        function(input, output) {
                
                output$oid2 <- renderPrint({input$id2})
                
                
                
                ## 
                
                
                #print(input$id2)
                #if (input$id2=="Theft") map2<-map2 + geom_point(aes(x = PlotTheft$X, y = PlotTheft$Y), data = PlotTheft, alpha = .1, color="red", size = 3)
                #if (input$id2=="Vehicle") map2<-map2 + geom_point(aes(x = PlotAssault$X, y = PlotAssault$Y), data = PlotAssault, alpha = .1, color="blue", size = 3)
                #if (input$id2=="Assault") map2<-map2 + geom_point(aes(x = PlotVehicle$X, y = PlotVehicle$Y), data = PlotVehicle, alpha = .2, color="darkgreen", size = 3)
                
                #map2<-hist(rnorm(100))

                output$newHist <- renderPlot({print(map1)})
                output$newHist2 <- renderPlot({print(tttp)})
        }
)