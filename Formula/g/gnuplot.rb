class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.8/gnuplot-5.4.8.tar.gz"
  sha256 "931279c7caad1aff7d46cb4766f1ff41c26d9be9daf0bcf0c79deeee3d91f5cf"
  license "gnuplot"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/gnuplot[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "d40df5c11e7f90b5ef3c489dff54bf405cf9125cda3de61f8fc24d0b3fcafd05"
    sha256 arm64_monterey: "2b0b0ae3446b80af02452bb2ff1f2a787c41ac3627bd7499bbb96ce35bac62ae"
    sha256 arm64_big_sur:  "52ed9426cb08b1bf9140ba75dcd6ef7b398fcf00c8f7246f1c93868f7b6570ab"
    sha256 ventura:        "3bea5e9917bda062beed8195e92bf1a4a723d344a522d1d1cd028e393e65d797"
    sha256 monterey:       "d416ea34c5dced922f6044f8d7ad0e273de282cd50182292f404bb0e5ff00d0f"
    sha256 big_sur:        "7d3ec01a6fc4c7ead43f764f26153a7c4346a84fecb87e4c015ac661074fdc2e"
    sha256 x86_64_linux:   "8a135d55cfe11b50e512cdad44b0a4be38bafa39d13f5828027fee46057cc032"
  end

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "qt"
  depends_on "readline"

  fails_with gcc: "5"

  # From upstream commit https://sourceforge.net/p/gnuplot/gnuplot-main/ci/e458b88e481e8af4ef2d97c9af79fdf40e40ed81/
  patch :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
      --disable-wxwidgets
      --with-qt
      --without-x
      --without-latex
      MOC=#{Formula["qt"].pkgshare}/libexec/moc
      RCC=#{Formula["qt"].pkgshare}/libexec/rcc
      UIC=#{Formula["qt"].pkgshare}/libexec/uic
    ]

    if OS.mac?
      # pkg-config files are not shipped on macOS, making our job harder
      # https://bugreports.qt.io/browse/QTBUG-86080
      # Hopefully in the future gnuplot can autodetect this information
      # https://sourceforge.net/p/gnuplot/feature-requests/560/
      qtcflags = []
      qtlibs = %W[-F#{Formula["qt"].opt_prefix}/Frameworks]
      %w[Core Gui Network Svg PrintSupport Widgets Core5Compat].each do |m|
        qtcflags << "-I#{Formula["qt"].opt_include}/Qt#{m}"
        qtlibs << "-framework Qt#{m}"
      end

      args += %W[
        QT_CFLAGS=#{qtcflags.join(" ")}
        QT_LIBS=#{qtlibs.join(" ")}
      ]
    end

    # Work around Qt 6 incompatibility
    # https://sourceforge.net/p/gnuplot/feature-requests/560/
    inreplace "src/qtterminal/QtGnuplotItems.cpp", "return metrics.width", "return metrics.horizontalAdvance"

    ENV.append "CXXFLAGS", "-std=c++17" # needed for Qt 6
    system "./prepare" if build.head?
    system "./configure", *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gnuplot", "-e", <<~EOS
      set terminal dumb;
      set output "#{testpath}/graph.txt";
      plot sin(x);
    EOS
    assert_predicate testpath/"graph.txt", :exist?
  end
end
__END__
diff -pur gnuplot-5.4.8/configure gnuplot-5.4.8-new/configure
--- gnuplot-5.4.8/configure	2023-06-02 05:20:07
+++ gnuplot-5.4.8-new/configure	2023-07-31 14:26:14
@@ -943,7 +943,7 @@ localstatedir='${prefix}/var'
 sysconfdir='${prefix}/etc'
 sharedstatedir='${prefix}/com'
 localstatedir='${prefix}/var'
-runstatedir='/run'
+runstatedir='${localstatedir}/run'
 includedir='${prefix}/include'
 oldincludedir='/usr/include'
 docdir='${datarootdir}/doc/${PACKAGE_TARNAME}'
@@ -1493,7 +1493,7 @@ Fine tuning of the installation directories:
   --sysconfdir=DIR        read-only single-machine data [PREFIX/etc]
   --sharedstatedir=DIR    modifiable architecture-independent data [PREFIX/com]
   --localstatedir=DIR     modifiable single-machine data [PREFIX/var]
-  --runstatedir=DIR       modifiable per-process data [/run]
+  --runstatedir=DIR       modifiable per-process data [LOCALSTATEDIR/run]
   --libdir=DIR            object code libraries [EPREFIX/lib]
   --includedir=DIR        C header files [PREFIX/include]
   --oldincludedir=DIR     C header files for non-gcc [/usr/include]
@@ -16274,12 +16274,15 @@ printf "%s\n" "$as_me: WARNING: No C++ compiler found.
       enable_qt_ok=no
   fi
 
-    if test "x${with_qt}" = "xqt5"; then
-    try_qt4=no
-  else
+    if test "x${with_qt}" = "xqt4"; then
     try_qt4=yes
+  else
+    try_qt4=no
   fi
+
   if test "x${with_qt}" != "xqt4"; then
+    { printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking Checking for Qt6 support libraries" >&5
+printf %s "checking Checking for Qt6 support libraries... " >&6; }
 
 pkg_failed=no
 { printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking for QT" >&5
@@ -16290,6 +16293,132 @@ if test -n "$PKG_CONFIG"; then
         pkg_cv_QT_CFLAGS="$QT_CFLAGS"
     else
         if test -n "$PKG_CONFIG" && \
+    { { printf "%s\n" "$as_me:${as_lineno-$LINENO}: \$PKG_CONFIG --exists --print-errors \"Qt6Core Qt6Gui Qt6Network Qt6Svg Qt6PrintSupport Qt6Core5Compat\""; } >&5
+  ($PKG_CONFIG --exists --print-errors "Qt6Core Qt6Gui Qt6Network Qt6Svg Qt6PrintSupport Qt6Core5Compat") 2>&5
+  ac_status=$?
+  printf "%s\n" "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
+  test $ac_status = 0; }; then
+  pkg_cv_QT_CFLAGS=`$PKG_CONFIG --cflags "Qt6Core Qt6Gui Qt6Network Qt6Svg Qt6PrintSupport Qt6Core5Compat" 2>/dev/null`
+else
+  pkg_failed=yes
+fi
+    fi
+else
+	pkg_failed=untried
+fi
+if test -n "$PKG_CONFIG"; then
+    if test -n "$QT_LIBS"; then
+        pkg_cv_QT_LIBS="$QT_LIBS"
+    else
+        if test -n "$PKG_CONFIG" && \
+    { { printf "%s\n" "$as_me:${as_lineno-$LINENO}: \$PKG_CONFIG --exists --print-errors \"Qt6Core Qt6Gui Qt6Network Qt6Svg Qt6PrintSupport Qt6Core5Compat\""; } >&5
+  ($PKG_CONFIG --exists --print-errors "Qt6Core Qt6Gui Qt6Network Qt6Svg Qt6PrintSupport Qt6Core5Compat") 2>&5
+  ac_status=$?
+  printf "%s\n" "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
+  test $ac_status = 0; }; then
+  pkg_cv_QT_LIBS=`$PKG_CONFIG --libs "Qt6Core Qt6Gui Qt6Network Qt6Svg Qt6PrintSupport Qt6Core5Compat" 2>/dev/null`
+else
+  pkg_failed=yes
+fi
+    fi
+else
+	pkg_failed=untried
+fi
+
+
+
+if test $pkg_failed = yes; then
+
+if $PKG_CONFIG --atleast-pkgconfig-version 0.20; then
+        _pkg_short_errors_supported=yes
+else
+        _pkg_short_errors_supported=no
+fi
+        if test $_pkg_short_errors_supported = yes; then
+	        QT_PKG_ERRORS=`$PKG_CONFIG --short-errors --errors-to-stdout --print-errors "Qt6Core Qt6Gui Qt6Network Qt6Svg Qt6PrintSupport Qt6Core5Compat"`
+        else
+	        QT_PKG_ERRORS=`$PKG_CONFIG --errors-to-stdout --print-errors "Qt6Core Qt6Gui Qt6Network Qt6Svg Qt6PrintSupport Qt6Core5Compat"`
+        fi
+	# Put the nasty error message in config.log where it belongs
+	echo "$QT_PKG_ERRORS" >&5
+
+	{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: WARNING:
+Package requirements (Qt6Core Qt6Gui Qt6Network Qt6Svg Qt6PrintSupport Qt6Core5Compat) were not met:
+
+$QT_PKG_ERRORS
+
+Consider adjusting the PKG_CONFIG_PATH environment variable if you
+installed software in a non-standard prefix.
+
+Alternatively, you may set the environment variables QT_CFLAGS
+and QT_LIBS to avoid the need to call pkg-config.
+See the pkg-config man page for more details.
+" >&5
+printf "%s\n" "$as_me: WARNING:
+Package requirements (Qt6Core Qt6Gui Qt6Network Qt6Svg Qt6PrintSupport Qt6Core5Compat) were not met:
+
+$QT_PKG_ERRORS
+
+Consider adjusting the PKG_CONFIG_PATH environment variable if you
+installed software in a non-standard prefix.
+
+Alternatively, you may set the environment variables QT_CFLAGS
+and QT_LIBS to avoid the need to call pkg-config.
+See the pkg-config man page for more details.
+" >&2;}
+elif test $pkg_failed = untried; then
+	{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: WARNING:
+The pkg-config script could not be found or is too old.  Make sure it
+is in your PATH or set the PKG_CONFIG environment variable to the full
+path to pkg-config.
+
+Alternatively, you may set the environment variables QT_CFLAGS
+and QT_LIBS to avoid the need to call pkg-config.
+See the pkg-config man page for more details.
+
+To get pkg-config, see <http://www.freedesktop.org/software/pkgconfig>." >&5
+printf "%s\n" "$as_me: WARNING:
+The pkg-config script could not be found or is too old.  Make sure it
+is in your PATH or set the PKG_CONFIG environment variable to the full
+path to pkg-config.
+
+Alternatively, you may set the environment variables QT_CFLAGS
+and QT_LIBS to avoid the need to call pkg-config.
+See the pkg-config man page for more details.
+
+To get pkg-config, see <http://www.freedesktop.org/software/pkgconfig>." >&2;}
+else
+	QT_CFLAGS=$pkg_cv_QT_CFLAGS
+	QT_LIBS=$pkg_cv_QT_LIBS
+        { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: yes" >&5
+printf "%s\n" "yes" >&6; }
+	:
+fi
+    if test $pkg_failed = no; then
+      QT6LOC=`$PKG_CONFIG --variable=host_bins Qt6Core`
+      if test "x${QT6LOC}" != "x"; then
+        UIC=${QT6LOC}/uic
+        MOC=${QT6LOC}/moc
+        RCC=${QT6LOC}/rcc
+        LRELEASE=${QT6LOC}/lrelease
+      fi
+      CXXFLAGS="$CXXFLAGS -fPIC"
+      { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: The Qt terminal will use Qt6." >&5
+printf "%s\n" "The Qt terminal will use Qt6." >&6; }
+      QTVER="6"
+    else
+      { printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking Checking for Qt5 support libraries" >&5
+printf %s "checking Checking for Qt5 support libraries... " >&6; }
+
+pkg_failed=no
+{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking for QT" >&5
+printf %s "checking for QT... " >&6; }
+
+if test -n "$PKG_CONFIG"; then
+    if test -n "$QT_CFLAGS"; then
+        pkg_cv_QT_CFLAGS="$QT_CFLAGS"
+    else
+        if test -n "$PKG_CONFIG" && \
     { { printf "%s\n" "$as_me:${as_lineno-$LINENO}: \$PKG_CONFIG --exists --print-errors \"Qt5Core Qt5Gui Qt5Network Qt5Svg Qt5PrintSupport\""; } >&5
   ($PKG_CONFIG --exists --print-errors "Qt5Core Qt5Gui Qt5Network Qt5Svg Qt5PrintSupport") 2>&5
   ac_status=$?
@@ -16391,20 +16520,25 @@ fi
 printf "%s\n" "yes" >&6; }
 	:
 fi
-    if test $pkg_failed = no; then
-      try_qt4=no
-      QT5LOC=`$PKG_CONFIG --variable=host_bins Qt5Core`
-      if test "x${QT5LOC}" != "x"; then
-        UIC=${QT5LOC}/uic
-        MOC=${QT5LOC}/moc
-        RCC=${QT5LOC}/rcc
-        LRELEASE=${QT5LOC}/lrelease
+      if test $pkg_failed = no; then
+        QT5LOC=`$PKG_CONFIG --variable=host_bins Qt5Core`
+        if test "x${QT5LOC}" != "x"; then
+          UIC=${QT5LOC}/uic
+          MOC=${QT5LOC}/moc
+          RCC=${QT5LOC}/rcc
+          LRELEASE=${QT5LOC}/lrelease
+        fi
+        CXXFLAGS="$CXXFLAGS -fPIC"
+        { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: The Qt terminal will use Qt5." >&5
+printf "%s\n" "The Qt terminal will use Qt5." >&6; }
+        QTVER="5"
       fi
-      CXXFLAGS="$CXXFLAGS -fPIC"
     fi
   fi
 
-    if test ${try_qt4} != no; then
+    if test ${try_qt4} = yes; then
+    { printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking Checking for Qt4 support" >&5
+printf %s "checking Checking for Qt4 support... " >&6; }
 
 pkg_failed=no
 { printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking for QT" >&5
@@ -16530,10 +16664,6 @@ printf "%s\n" "The Qt terminal will use Qt4." >&6; }
 printf "%s\n" "The Qt terminal will use Qt4." >&6; }
       QTVER="4"
     fi
-  else
-    { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: The Qt terminal will use Qt5." >&5
-printf "%s\n" "The Qt terminal will use Qt5." >&6; }
-    QTVER="5"
   fi
 fi
 
@@ -18588,6 +18718,10 @@ printf "%s\n" "  Qt terminal: yes (qt5)" >&6; }
   if test "$QTVER" = 5; then
       { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result:   Qt terminal: yes (qt5)" >&5
 printf "%s\n" "  Qt terminal: yes (qt5)" >&6; }
+  fi
+  if test "$QTVER" = 6; then
+      { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result:   Qt                   : yes (qt6)" >&5
+printf "%s\n" "  Qt                   : yes (qt6)" >&6; }
   fi
 else
   { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result:   Qt terminal: no (use --with-qt or --with-qt=qt4 to enable" >&5
diff -pur gnuplot-5.4.8/configure.ac gnuplot-5.4.8-new/configure.ac
--- gnuplot-5.4.8/configure.ac	2023-06-02 01:13:08
+++ gnuplot-5.4.8-new/configure.ac	2023-07-31 14:26:04
@@ -990,29 +990,48 @@ if test "${enable_qt}" = yes ; then
       enable_qt_ok=no
   fi
 
-  dnl First check for Qt5
-  if test "x${with_qt}" = "xqt5"; then
-    try_qt4=no
-  else
+  dnl Qt4 only by special request
+  if test "x${with_qt}" = "xqt4"; then
     try_qt4=yes
+  else
+    try_qt4=no
   fi
+
   if test "x${with_qt}" != "xqt4"; then
-    PKG_CHECK_MODULES_NOFAIL(QT, [Qt5Core Qt5Gui Qt5Network Qt5Svg Qt5PrintSupport])
+    AC_MSG_CHECKING([Checking for Qt6 support libraries])
+    PKG_CHECK_MODULES_NOFAIL(QT, [Qt6Core Qt6Gui Qt6Network Qt6Svg Qt6PrintSupport Qt6Core5Compat])
     if test $pkg_failed = no; then
-      try_qt4=no
-      QT5LOC=`$PKG_CONFIG --variable=host_bins Qt5Core`
-      if test "x${QT5LOC}" != "x"; then
-        UIC=${QT5LOC}/uic
-        MOC=${QT5LOC}/moc
-        RCC=${QT5LOC}/rcc
-        LRELEASE=${QT5LOC}/lrelease
+      QT6LOC=`$PKG_CONFIG --variable=host_bins Qt6Core`
+      if test "x${QT6LOC}" != "x"; then
+        UIC=${QT6LOC}/uic
+        MOC=${QT6LOC}/moc
+        RCC=${QT6LOC}/rcc
+        LRELEASE=${QT6LOC}/lrelease
       fi
       CXXFLAGS="$CXXFLAGS -fPIC"
+      AC_MSG_RESULT([The Qt terminal will use Qt6.])
+      QTVER="6"
+    else
+      AC_MSG_CHECKING([Checking for Qt5 support libraries])
+      PKG_CHECK_MODULES_NOFAIL(QT, [Qt5Core Qt5Gui Qt5Network Qt5Svg Qt5PrintSupport])
+      if test $pkg_failed = no; then
+        QT5LOC=`$PKG_CONFIG --variable=host_bins Qt5Core`
+        if test "x${QT5LOC}" != "x"; then
+          UIC=${QT5LOC}/uic
+          MOC=${QT5LOC}/moc
+          RCC=${QT5LOC}/rcc
+          LRELEASE=${QT5LOC}/lrelease
+        fi
+        CXXFLAGS="$CXXFLAGS -fPIC"
+        AC_MSG_RESULT([The Qt terminal will use Qt5.])
+        QTVER="5"
+      fi
     fi 
   fi
 
-  dnl No Qt5, check for Qt4.5 or greater
-  if test ${try_qt4} != no; then
+  dnl Explicit request for qt4 
+  if test ${try_qt4} = yes; then
+    AC_MSG_CHECKING([Checking for Qt4 support])
     PKG_CHECK_MODULES_NOFAIL(QT, [QtCore >= 4.5 QtGui >= 4.5 QtNetwork >= 4.5 QtSvg >= 4.5])
     if test $pkg_failed != no; then
       enable_qt_ok=no
@@ -1026,9 +1045,6 @@ if test "${enable_qt}" = yes ; then
       AC_MSG_RESULT([The Qt terminal will use Qt4.])
       QTVER="4"
     fi
-  else
-    AC_MSG_RESULT([The Qt terminal will use Qt5.])
-    QTVER="5"
   fi
 fi
 
@@ -1282,6 +1298,9 @@ if test "$enable_qt_ok" = yes; then
   fi
   if test "$QTVER" = 5; then
       AC_MSG_RESULT([  Qt terminal: yes (qt5)])
+  fi
+  if test "$QTVER" = 6; then
+      AC_MSG_RESULT([  Qt                   : yes (qt6)])
   fi
 else
   AC_MSG_RESULT([  Qt terminal: no (use --with-qt or --with-qt=qt4 to enable])
diff -pur gnuplot-5.4.8/src/qtterminal/qt_conversion.cpp gnuplot-5.4.8-new/src/qtterminal/qt_conversion.cpp
--- gnuplot-5.4.8/src/qtterminal/qt_conversion.cpp	2017-12-22 18:32:30
+++ gnuplot-5.4.8-new/src/qtterminal/qt_conversion.cpp	2023-07-31 14:26:04
@@ -41,6 +41,15 @@
  * under either the GPL or the gnuplot license.
 ]*/
 
+/*
+ * Qt6 no longer supports other 8-bit encodings natively, relegating the
+ * QTextCodec functions to a compatibility module Core5Compat.
+ * FIXME: roll our own?
+ */
+#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
+    #include <QTextCodec>
+#endif
+
 static QColor qt_colorList[12] =
 {
 	Qt::white,
