import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');
  bool _showSplash = true;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void toggleLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'en'
          ? const Locale('bn')
          : const Locale('en');
    });
  }

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Way To Din',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('bn')],
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
      ),
      home: _showSplash
          ? SplashScreen(onInitializationComplete: _onSplashComplete)
          : HomeActivity(
              toggleTheme: toggleTheme,
              toggleLanguage: toggleLanguage,
              currentLocale: _locale,
            ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  const SplashScreen({super.key, required this.onInitializationComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    Timer(const Duration(seconds: 3), () {
      widget.onInitializationComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.star, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text(
                "Way To Din",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeActivity extends StatefulWidget {
  final VoidCallback toggleTheme;
  final VoidCallback toggleLanguage;
  final Locale currentLocale;

  const HomeActivity({
    super.key,
    required this.toggleTheme,
    required this.toggleLanguage,
    required this.currentLocale,
  });

  @override
  State<HomeActivity> createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  void mySnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// ✅✅ FIXED FUNCTION BELOW
  Future<void> _launchURL(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    mySnackBar('Could not launch URL', context);
  }
}


  Widget sideButton(
      IconData icon, String tooltip, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        hoverColor: Colors.white10,
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 5),
            Text(
              tooltip,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  final List<String> islamicTitlesEn = [
    "Islamic History",
    "Daily Dua",
    "Prayer Time",
    "Hadith of the Day",
    "Quran Recitation",
    "Ramadan Tips",
    "Fasting Rules",
    "Zakat Guide",
    "Islamic Quotes",
    "Shahada Explanation",
    "Tawheed (Oneness)",
    "Islamic Names",
    "99 Names of Allah",
    "Prophets Stories",
    "Friday Khutbah",
    "Hajj & Umrah",
    "Halal Food Guide",
    "Islamic Calendar",
    "Sunnah Practices",
    "Fiqh Basics",
  ];

  final List<String> islamicTitlesBn = [
    "ইসলামিক ইতিহাস",
    "দৈনিক দোয়া",
    "নামাজের সময়",
    "আজকের হাদিস",
    "কুরআন তেলাওয়াত",
    "রমজানের টিপস",
    "রোজার নিয়ম",
    "যাকাত গাইড",
    "ইসলামিক উক্তি",
    "শাহাদা ব্যাখ্যা",
    "তাওহীদ (একত্ববাদের ব্যাখ্যা)",
    "ইসলামিক নাম",
    "আল্লাহর ৯৯ নাম",
    "নবীজির গল্প",
    "শুক্রবারের খুতবা",
    "হজ ও ওমরাহ",
    "হালাল খাবারের গাইড",
    "ইসলামিক ক্যালেন্ডার",
    "সুন্নাহর অভ্যাস",
    "ফিকহের বেসিকস",
  ];

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    bool isEnglish = widget.currentLocale.languageCode == 'en';

    List<String> islamicTitles = isEnglish ? islamicTitlesEn : islamicTitlesBn;

    String appBarTitle = isEnglish ? "Way To Din" : "দীন এর পথ";
    String languageTooltip = isEnglish ? "Switch Language" : "ভাষা পরিবর্তন";

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 5, 174, 141),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.white,
              size: 28,
            ),
            title: Text(
              appBarTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.language),
                onPressed: widget.toggleLanguage,
                tooltip: languageTooltip,
                color: Colors.white,
              ),
              IconButton(
                icon: Icon(
                  isLightTheme ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.white,
                ),
                onPressed: widget.toggleTheme,
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color.fromARGB(255, 2, 134, 110),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 5, 174, 141),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://thumbs.dreamstime.com/b/mosque-islamic-logo-icon-ramadhan-kareem-icon-design-mosque-islamic-logo-icon-380891812.jpg'),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Way To Din',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              drawerTile(Icons.home, isEnglish ? 'Home' : 'হোম', () {
                Navigator.pop(context);
                mySnackBar(isEnglish ? "Home tapped" : "হোমে ট্যাপ করা হয়েছে",
                    context);
              }),
              drawerTile(Icons.settings, isEnglish ? 'Settings' : 'সেটিংস', () {
                Navigator.pop(context);
                mySnackBar(
                    isEnglish
                        ? "Settings tapped"
                        : "সেটিংসে ট্যাপ করা হয়েছে",
                    context);
              }),
              const Divider(color: Colors.white54),
              drawerTile(
                  Icons.info_outline,
                  isEnglish ? 'About Us' : 'আমাদের সম্পর্কে', () {
                Navigator.pop(context);
                mySnackBar(
                    isEnglish
                        ? "This is Way To Din app."
                        : "এটি দীন এর পথ অ্যাপ।",
                    context);
              }),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              isLightTheme
                  ? 'https://i.postimg.cc/6Q56yr0Y/islamic-background-gray-arabic-muslim-holy-month-ramadan-kareem-mosque-wallpaper-banner-1008660-1251.jpg'
                  : 'https://i.postimg.cc/L6TLWZKT/abstract-background-with-traditional-ornament-vector-6214395.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 90,
              color: Colors.black,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  sideButton(Icons.menu_book, isEnglish ? "Quran" : "কুরআন",
                      Colors.green, () {
                    _launchURL('http://www.quran.gov.bd/');
                  }),
                  sideButton(Icons.auto_stories, isEnglish ? "Hadis" : "হাদিস",
                      Colors.orange, () {
                    _launchURL('https://ihadis.com/');
                  }),
                  sideButton(Icons.access_time, isEnglish ? "Clock" : "ঘড়ি",
                      Colors.cyan, () {
                    _launchURL('https://time.is/');
                  }),
                  sideButton(Icons.calendar_month,
                      isEnglish ? "Calendar" : "ক্যালেন্ডার", Colors.purple,
                      () {
                    _launchURL('https://calendar.google.com/');
                  }),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: islamicTitles.length,
                itemBuilder: (context, index) {
                  final title = islamicTitles[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: GestureDetector(
                      onTap: () {
                        mySnackBar(
                          isEnglish
                              ? 'Tapped on $title'
                              : '${index + 1} নম্বর আইটেমে ট্যাপ করা হয়েছে',
                          context,
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            'https://i.postimg.cc/NFJKDmSC/luxury-golden-arabic-islamic-text-box-title-frame-border-banner-set-multiple-colors-for-ramadan-and.png',
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: 80,
                          ),
                          Center(
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 249, 251, 251),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile drawerTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
