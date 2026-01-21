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
    sha256 arm64_tahoe:   "f157397b6c5fa83a8d4e2dd1cb54ef060ab3b6c2298554a8006ccd89bd6ad427"
    sha256 arm64_sequoia: "c6a93e99ea54d741a02c28858ef4cedb959c039c425ad28fe37f6b47d68a40e2"
    sha256 arm64_sonoma:  "2667a87710cdf581a8066c19cae2916cf6809f39eaa8437bba648943d6ff1cc8"
    sha256 sonoma:        "c8e2916309b3431fc392e98de5f8ccd8b99534f0e19513756c9b8189155100a0"
    sha256 arm64_linux:   "47e3e27c14637c56a991c08256ff8a523325052d54989f6879e94998dce31ddf"
    sha256 x86_64_linux:  "81002efd521f8c2818f7182c6215feb390a9400c67eb0a1c47991702563bab86"
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
