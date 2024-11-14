import 'dart:ui_web';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapApp(),
    );
  }
}

class MapApp extends StatefulWidget {
  const MapApp({super.key});

  @override
  State<MapApp> createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  LatLng point = LatLng(10.82, 106.62);
  final LayerHitNotifier hitNotifier = ValueNotifier(null);
  var location;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          //mapController: MapController(),
          options: MapOptions(
            initialCenter: point,
            initialZoom: 10,
            maxZoom: 80,
            minZoom: 5,
            onTap: (tapPoint, latlngPoint) {
              // location = await placemarkFromCoordinates(
              //     latlngPoint.latitude, latlngPoint.longitude);
              // print("${location.first.countryName}");
              setState(() {
                point = latlngPoint;
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 100.0,
                  height: 100.0,
                  point: point,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  )
                )
            ]),
            PolygonLayer(
              hitNotifier: hitNotifier,
              polygons: [
                Polygon(
                  points: [LatLng(10, 105), LatLng(10, 106), LatLng(10.5, 105.5)],
                  color: Colors.lightBlue,
                  hitValue: "Triangle",
                ),
              ],
            ),
            CircleLayer(
              hitNotifier: hitNotifier,
              circles: [
                CircleMarker(
                  point: LatLng(10.62, 106.62),
                  radius: 10000,
                  useRadiusInMeter: true,
                  hitValue: "Circle",
                ),
              ],
            ),
            OverlayImageLayer(
              overlayImages: [
                OverlayImage( // Unrotated
                  bounds: LatLngBounds(
                    LatLng(10.32, 106.32),
                    LatLng(10.42, 106.42),
                  ),
                  imageProvider: NetworkImage("https://picsum.photos/250?image=9")
                ),
              ],
            ),
            SimpleAttributionWidget(
              source: Text('Seminar flutter'),

            ),
            PolylineLayer(
              hitNotifier: hitNotifier,
              polylines: [
                Polyline(
                  points: [LatLng(10.30, 106.30), LatLng(10.20, 106.20), LatLng(10.20, 106)],
                  color: Colors.red,
                  strokeWidth: 10,
                  hitValue: "Line",
                ),
              ],
            ),
          ],

        ),
        MouseRegion(
          hitTestBehavior: HitTestBehavior.deferToChild,
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              location = hitNotifier.value?.hitValues.last;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined),
                    hintText: "Search for location",
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "${location}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

