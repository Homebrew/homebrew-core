class Gwyddion < Formula
  desc "Scanning Probe Microscopy visualization and analysis tool"
  homepage "https://gwyddion.net/"
  url "https://downloads.sourceforge.net/project/gwyddion/gwyddion/2.69/gwyddion-2.69.tar.xz"
  sha256 "597eb6b51ee575a07f350cc0573bc74d005a3490d9832ad136a369e70d30efa6"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://gwyddion.net/download.php"
    regex(/stable\s+version\s+Gwyddion\s+v?(\d+(?:\.\d+)+)[:<\s]/im)
  end

  bottle do
    sha256 arm64_tahoe:   "176d61f7d6e3b0ddd007cad44c7d197c2f67cdd4d0bbc36b743ebbbcb585f721"
    sha256 arm64_sequoia: "ea2b00bae6b56f8815f46d8d433e88b0713e1edf3a3e0b9ba4cd579b731351a0"
    sha256 arm64_sonoma:  "6b456d84c768c7878ec6ca5b26d980e0959661ec5470fb41883f7864b5d8b739"
    sha256 sonoma:        "41fa3671e4dca128efbffba0d0dcaca79c68f1d6f13b7d5449a21ea039a784b1"
    sha256 arm64_linux:   "9fccd8372bc3dd8306783ec7474cbebaa83fea152fcd444778fa6f3bb8c34e83"
    sha256 x86_64_linux:  "4572185617765888be6da573667d3f704b7494966d5923de5a740d1602aa0cfd"
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
