class Gwyddion < Formula
  desc "Scanning Probe Microscopy visualization and analysis tool"
  homepage "https://gwyddion.net/"
  url "https://downloads.sourceforge.net/project/gwyddion/gwyddion/2.70/gwyddion-2.70.tar.xz"
  sha256 "942f4e041945a850bc32d05193a115ac8a5118a6f841afa6d4dea510f9913f59"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://gwyddion.net/download.php"
    regex(/stable\s+version\s+Gwyddion\s+v?(\d+(?:\.\d+)+)[:<\s]/im)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "2a9be119dd5c8893162a0dcbfac468e8d92b8542e308005b171d98e671d1017d"
    sha256 arm64_sequoia: "946f4dd90604f6e89c8fc696786ca9c67c2f74252e2ead399f29dc434490a303"
    sha256 arm64_sonoma:  "65d5b8eb804d4d996544ce6e70caba8c6cb54f41a0639015f1ad84bd381822fd"
    sha256 sonoma:        "507f7a6ed8de871c6e6ea6576ede975c04bff306deeaeb9511b6e2c4a23d7944"
    sha256 arm64_linux:   "e73cf62e1f3a43063c484d2bbdc962a7f94ef40b6e1688b8eb657bbb40bf9bf6"
    sha256 x86_64_linux:  "2abe37cb9a8afe42ec478fb057e3dfc4ca19ca1de0b5428ace7df39ab8cc5a2b"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "fftw"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "gtkglext"
  depends_on "libpng"
  depends_on "libxml2"
  depends_on "minizip"
  depends_on "pango"

  uses_from_macos "bzip2"

  on_macos do
    # Regenerate autoconf files to avoid flat namespace in library
    # (autoreconf runs gtkdocize, provided by gtk-doc)
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    # TODO: depends_on "gtk-mac-integration"
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix Autoconf ≥2.72 compatibility by explicitly declaring gettext version.
  patch :DATA

  def install
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?
    system "./configure", "--disable-desktop-file-update",
                          "--disable-pygwy",
                          "--disable-silent-rules",
                          "--with-html-dir=#{doc}",
                          "--without-gtksourceview",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gwyddion", "--version"
    (testpath/"test.c").write <<~C
      #include <libgwyddion/gwyddion.h>

      int main(int argc, char *argv[]) {
        const gchar *string = gwy_version_string();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gwyddion").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index b1f75d4..8a0895c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -883,6 +883,7 @@ AC_CHECK_FUNCS([sincos log2 exp2 lgamma tgamma j0 j1 y0 y1 log1p expm1 memrchr m
 #############################################################################
 # I18n
 GETTEXT_PACKAGE=$PACKAGE_TARNAME
+AM_GNU_GETTEXT_VERSION([0.19])
 AM_GNU_GETTEXT([external])
 AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE,"$GETTEXT_PACKAGE",[Gettext package name])
 AC_SUBST(GETTEXT_PACKAGE)
