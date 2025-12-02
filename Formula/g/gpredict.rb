class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "https://oz9aec.dk/gpredict/"
  license "GPL-2.0-or-later"
  revision 4

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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "00a4b8168a49d8832067ae38062fbb27ee4832128dd1477ca0c04d9121e1b018"
    sha256 arm64_sequoia:  "4403289b0462934585554618873510ff96c04fde9853e6aeb3ddc048fd98ba31"
    sha256 arm64_sonoma:   "a2f0896b69d12cc6fcefff733bb0c1f8dad89309125453ad660b3bca6d6bfb1d"
    sha256 arm64_ventura:  "6e7826d912ce8ab58e41957be7c2f5430e72a8dd1d4e12da7c1500e167c3135a"
    sha256 arm64_monterey: "10d957077407004e9a1f24871417521fc89ce9400a28880d606357d6c97b9153"
    sha256 sonoma:         "1f22599c86203b19a4a41d0b99b8a149ba6a5453f77f870af3febc88b41b8086"
    sha256 ventura:        "e87506b7e96f33c83ba138514835c060ea7f8574a2c85547264c03fe666ae5bc"
    sha256 monterey:       "ba26824909be3fb95aceca85485c8e858071f1e0ad861c7c9e541630859a1dc4"
    sha256 arm64_linux:    "e225f47753f56821f579153f77e91f03dce0150f9065bf2f4d962987eaaa7980"
    sha256 x86_64_linux:   "e81cbab517c5a422abe3f0cc1a2fdac16b9c6d118949d343dfd30cd4d5026e8d"
  end

  head do
    url "https://github.com/csete/gpredict.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "goocanvas"
  depends_on "gtk+3"
  depends_on "hamlib"
  depends_on "pango"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
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
