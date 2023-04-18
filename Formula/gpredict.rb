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
    sha256 arm64_ventura:  "afe4cc604e87a3446fac9a882292efa4ded782ee40e6b2bfee9549c4ea1c285e"
    sha256 arm64_monterey: "269c3a416e968dcc1ebddeb7580660acb9568387121a52cd5dae4a421747ea2f"
    sha256 arm64_big_sur:  "ef852387a0eeb9e19c38fabcf717c58f5a4924bb11c93a79ed214aa41dc5e0a3"
    sha256 ventura:        "c388efa5790d4a364a46af6210c0ef9e3e750c37413b4c3d315a039caa804a5c"
    sha256 monterey:       "6486c396b33ef98057502fa04c9f8e53cd91493d541635ba9c04b61323be189f"
    sha256 big_sur:        "914edd91da98b60ce958b96c2ff8c83f23d94ccb9b486beb745acc7766fa1686"
    sha256 catalina:       "a7b78f175543acdab3731927cf266e33ccc571e439fe8e8662539bcc877f7956"
    sha256 x86_64_linux:   "1256d49da41bbf2ebdda5da63e372143a323021e93e7e5e12cc9db3faf833272"
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
