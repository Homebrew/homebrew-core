class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "http://gpredict.oz9aec.net/"
  url "https://github.com/csete/gpredict/releases/download/v2.2.1/gpredict-2.2.1.tar.bz2"
  sha256 "e759c4bae0b17b202a7c0f8281ff016f819b502780d3e77b46fe8767e7498e43"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "eccf4afd811d590ed5c930840933905bd5b1ea9bdf42e32e52cf4926d0c1eb05" => :big_sur
    sha256 "2c367d6266bd0af3583827c588ab864c26043444ad6b6379821c1b93e5093352" => :arm64_big_sur
    sha256 "99fff9473dcc5eaa0c58cf0b2bf04f4240e1598aada45565e4dbbf050d2ac7dc" => :catalina
    sha256 "952941a2ecdb5f75805888dfd020acce48c4f1b29a9c2e3ec8742d35fcd9c829" => :mojave
    sha256 "189249444c490bc7984506a3d041de1d057fff671ff774871f549f6b32efa042" => :high_sierra
    sha256 "9a0a4b0e63b3b1f84830f508d60ee3fc5b5fd0b9a5731241873168baa88209cf" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gettext"
  depends_on "glib"
  depends_on "goocanvas"
  depends_on "gtk+3"
  depends_on "hamlib"

  uses_from_macos "curl"

  # remove in next release
  # https://github.com/csete/gpredict/pull/251
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "real-time", shell_output("#{bin}/gpredict -h")
  end
end

__END__
diff --git a/configure b/configure
index 1533336..bf772e7 100755
--- a/configure
+++ b/configure
@@ -12773,11 +12773,11 @@ else
 fi

 # check for goocanvas (depends on gtk and glib)
-if pkg-config --atleast-version=2.0 goocanvas-2.0; then
-    CFLAGS="$CFLAGS `pkg-config --cflags goocanvas-2.0`"
-    LIBS="$LIBS `pkg-config --libs goocanvas-2.0`"
+if pkg-config --atleast-version=3.0 goocanvas-3.0; then
+    CFLAGS="$CFLAGS `pkg-config --cflags goocanvas-3.0`"
+    LIBS="$LIBS `pkg-config --libs goocanvas-3.0`"
 else
-    as_fn_error $? "Gpredict requires libgoocanvas-2.0-dev" "$LINENO" 5
+    as_fn_error $? "Gpredict requires libgoocanvas-3.0-dev" "$LINENO" 5
 fi

 # check for libgps (optional)
@@ -13553,7 +13553,7 @@ GIO_V=`pkg-config --modversion gio-2.0`
 GTHR_V=`pkg-config --modversion gthread-2.0`
 GDK_V=`pkg-config --modversion gdk-3.0`
 GTK_V=`pkg-config --modversion gtk+-3.0`
-GOOC_V=`pkg-config --modversion goocanvas-2.0`
+GOOC_V=`pkg-config --modversion goocanvas-3.0`
 CURL_V=`pkg-config --modversion libcurl`
 if test "$havelibgps" = true ; then
    GPS_V=`pkg-config --modversion libgps`
@@ -15915,4 +15915,3 @@ if test "$havelibgps" = true ; then
 fi
 # echo Enable coverage.... : $enable_coverage
 # echo
-
diff --git a/configure.ac b/configure.ac
index e3fe564..5df1ecb 100644
--- a/configure.ac
+++ b/configure.ac
@@ -45,11 +45,11 @@ else
 fi

 # check for goocanvas (depends on gtk and glib)
-if pkg-config --atleast-version=2.0 goocanvas-2.0; then
-    CFLAGS="$CFLAGS `pkg-config --cflags goocanvas-2.0`"
-    LIBS="$LIBS `pkg-config --libs goocanvas-2.0`"
+if pkg-config --atleast-version=3.0 goocanvas-3.0; then
+    CFLAGS="$CFLAGS `pkg-config --cflags goocanvas-3.0`"
+    LIBS="$LIBS `pkg-config --libs goocanvas-3.0`"
 else
-    AC_MSG_ERROR(Gpredict requires libgoocanvas-2.0-dev)
+    AC_MSG_ERROR(Gpredict requires libgoocanvas-3.0-dev)
 fi

 # check for libgps (optional)
@@ -93,12 +93,12 @@ GIO_V=`pkg-config --modversion gio-2.0`
 GTHR_V=`pkg-config --modversion gthread-2.0`
 GDK_V=`pkg-config --modversion gdk-3.0`
 GTK_V=`pkg-config --modversion gtk+-3.0`
-GOOC_V=`pkg-config --modversion goocanvas-2.0`
+GOOC_V=`pkg-config --modversion goocanvas-3.0`
 CURL_V=`pkg-config --modversion libcurl`
 if test "$havelibgps" = true ; then
    GPS_V=`pkg-config --modversion libgps`
 fi
-
+

 AC_SUBST(CFLAGS)
 AC_SUBST(LDFLAGS)
@@ -138,4 +138,3 @@ if test "$havelibgps" = true ; then
 fi
 # echo Enable coverage.... : $enable_coverage
 # echo
-
