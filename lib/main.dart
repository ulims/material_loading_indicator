import 'package:flutter/material.dart';
import 'package:material_loading_indicator/loading_indicator.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();

    final platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    _themeMode = platformBrightness == Brightness.light
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 80,
            runSpacing: 80,
            children: [
              SizedBox.square(
                dimension: 160,
                child: LoadingIndicator(),
              ),
              SizedBox.square(
                dimension: 160,
                child: LoadingIndicator.contained(),
              ),
            ],
          ),
        ),
        floatingActionButton: ClipOval(
          child: IconButton.outlined(
            constraints: const BoxConstraints.tightFor(width: 48, height: 48),
            onPressed: () {
              setState(() {
                _themeMode = _themeMode == ThemeMode.light
                    ? ThemeMode.dark
                    : ThemeMode.light;
              });
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                final isEntering = animation.status == AnimationStatus.forward;
                final isIcon2 = child.key == const ValueKey(ThemeMode.light);

                final startOffset = isEntering
                    ? (isIcon2 ? const Offset(0, 1) : const Offset(0, -1))
                    : (isIcon2 ? const Offset(0, -1) : const Offset(0, 1));

                final slide = Tween<Offset>(
                  begin: startOffset,
                  end: Offset.zero,
                ).animate(animation);

                final fade = animation;

                return SlideTransition(
                  position: slide,
                  child: FadeTransition(
                    opacity: fade,
                    child: child,
                  ),
                );
              },
              child: Icon(
                key: ValueKey(_themeMode),
                _themeMode == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
