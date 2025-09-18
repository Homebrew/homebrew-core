class Gwyddion < Formula
  desc "Scanning Probe Microscopy visualization and analysis tool"
  homepage "https://gwyddion.net/"
  url "https://downloads.sourceforge.net/project/gwyddion/gwyddion/2.69/gwyddion-2.69.tar.xz"
  sha256 "597eb6b51ee575a07f350cc0573bc74d005a3490d9832ad136a369e70d30efa6"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://gwyddion.net/download.php"
    regex(/stable\s+version\s+Gwyddion\s+v?(\d+(?:\.\d+)+)[:<\s]/im)
  end

  bottle do
    sha256 arm64_sonoma:  "d123e0af0f28d068466325379d28bfccc2490d4f951cec4ad09cd0c2cd7992d0"
    sha256 arm64_ventura: "738c889de97a30e82afbb7a655b8c1e00f14a774e7931e74e0a33940f81f3932"
    sha256 sonoma:        "42295b2db20740abd1ab4c497ad76c6a885054e47426b6795472dc65ca6f6eb6"
    sha256 ventura:       "ce04ffc46b39091dc6fcc77c620b4c0dd08ee0981a80e9ad92de47b8ff2c7261"
    sha256 arm64_linux:   "c79557b841749f565a46e5c591c025b7afe25ccbdbb90b141a5bc13965c130f5"
    sha256 x86_64_linux:  "e44417231b441de439df506d5505169bce65f230516a368456959b4dcb984436"
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
  uses_from_macos "zlib"

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
