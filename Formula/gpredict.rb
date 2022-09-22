class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "http://gpredict.oz9aec.net/"
  license "GPL-2.0-or-later"
  revision 3

  stable do
    url "https://github.com/csete/gpredict/releases/download/v2.2.1/gpredict-2.2.1.tar.bz2"
    sha256 "e759c4bae0b17b202a7c0f8281ff016f819b502780d3e77b46fe8767e7498e43"

    # Dependencies to regenerate configure for patch. Remove in the next release
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # Fix compilation with GCC 10+. Remove in the next release.
    # Issue ref: https://github.com/csete/gpredict/issues/195
    patch do
      url "https://github.com/csete/gpredict/commit/c565bb3d48777bfe17114b5d01cd81150521f056.patch?full_index=1"
      sha256 "fbefbb898a565cb830006996803646d755729bd4d5307a3713274729d1778462"
    end

    # Backport support for GooCanvas 3. Remove in the next release along with `autoreconf`
    # Ref: https://github.com/csete/gpredict/commit/86fb71aad0bba311268352539b61225bf1f1e279
    patch :DATA
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "f873648c8df2b0e87c6b2c6e7553379ca0e239738a01f83a702788f33ba0dcc9"
    sha256 arm64_big_sur:  "2c367d6266bd0af3583827c588ab864c26043444ad6b6379821c1b93e5093352"
    sha256 monterey:       "650854e63dd2ed7f88d40188575d69f5e83e311ebecfc489c13c472adfd5e947"
    sha256 big_sur:        "eccf4afd811d590ed5c930840933905bd5b1ea9bdf42e32e52cf4926d0c1eb05"
    sha256 catalina:       "99fff9473dcc5eaa0c58cf0b2bf04f4240e1598aada45565e4dbbf050d2ac7dc"
    sha256 mojave:         "952941a2ecdb5f75805888dfd020acce48c4f1b29a9c2e3ec8742d35fcd9c829"
    sha256 high_sierra:    "189249444c490bc7984506a3d041de1d057fff671ff774871f549f6b32efa042"
    sha256 sierra:         "9a0a4b0e63b3b1f84830f508d60ee3fc5b5fd0b9a5731241873168baa88209cf"
    sha256 x86_64_linux:   "e87f34490c8549a80627a714275d1ab1f9b73285ea76f28c91b6f45a360963bc"
  end

  head do
    url "https://github.com/csete/gpredict.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gettext"
  depends_on "glib"
  depends_on "goocanvas"
  depends_on "gtk+3"
  depends_on "hamlib"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" if OS.linux?

    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh", *std_configure_args
    else
      system "autoreconf", "--force", "--install", "--verbose" # TODO: remove in the next release
      system "./configure", *std_configure_args
    end
    system "make", "install"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "real-time", shell_output("#{bin}/gpredict -h")
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index e3fe564..d50615f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -44,12 +44,19 @@ else
     AC_MSG_ERROR(Gpredict requires libglib-dev 2.32 or later)
 fi
 
-# check for goocanvas (depends on gtk and glib)
+# check for goocanvas 2 or 3 (depends on gtk and glib)
 if pkg-config --atleast-version=2.0 goocanvas-2.0; then
     CFLAGS="$CFLAGS `pkg-config --cflags goocanvas-2.0`"
     LIBS="$LIBS `pkg-config --libs goocanvas-2.0`"
+    havegoocanvas2=true
 else
-    AC_MSG_ERROR(Gpredict requires libgoocanvas-2.0-dev)
+	if pkg-config --atleast-version=3.0 goocanvas-3.0; then
+		CFLAGS="$CFLAGS `pkg-config --cflags goocanvas-3.0`"
+		LIBS="$LIBS `pkg-config --libs goocanvas-3.0`"
+		havegoocanvas3=true
+	else
+		AC_MSG_ERROR(Gpredict requires libgoocanvas-2.0-dev)
+	fi
 fi
 
 # check for libgps (optional)
@@ -93,8 +100,13 @@ GIO_V=`pkg-config --modversion gio-2.0`
 GTHR_V=`pkg-config --modversion gthread-2.0`
 GDK_V=`pkg-config --modversion gdk-3.0`
 GTK_V=`pkg-config --modversion gtk+-3.0`
-GOOC_V=`pkg-config --modversion goocanvas-2.0`
 CURL_V=`pkg-config --modversion libcurl`
+if test "$havegoocanvas2" = true ;  then
+	GOOC_V=`pkg-config --modversion goocanvas-2.0`
+fi
+if test "$havegoocanvas3" = true ;  then
+	GOOC_V=`pkg-config --modversion goocanvas-3.0`
+fi
 if test "$havelibgps" = true ; then
    GPS_V=`pkg-config --modversion libgps`
 fi
