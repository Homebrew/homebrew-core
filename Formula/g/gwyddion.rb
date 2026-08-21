class Gwyddion < Formula
  desc "Scanning Probe Microscopy visualization and analysis tool"
  homepage "https://gwyddion.net/"
  license "GPL-2.0-or-later"

  stable do
    url "https://downloads.sourceforge.net/project/gwyddion/gwyddion/2.71/gwyddion-2.71.tar.xz"
    sha256 "2df721befccbe4d5ee2ba564b32e69341f8ce1de637e2045838a09a2d46b5dba"

    depends_on "gtk+"
  end

  livecheck do
    url "https://gwyddion.net/download.php"
    regex(/stable\s+version\s+Gwyddion\s+v?(\d+(?:\.\d+)+)[:<\s]/im)
  end

  bottle do
    sha256 arm64_tahoe:   "0b68818a49fef20580c6d7f3055ad7e108fda64592c4e66353dbe91762ab2830"
    sha256 arm64_sequoia: "2bf33cea35773f3a6db7ff6a6c80700ceeffe32c382c3710c82be3ac1f57a646"
    sha256 arm64_sonoma:  "79abadad092e0670df97cc6078ac31c0f7e88f1e78baee412b62087bc76aa848"
    sha256 sonoma:        "9fa8d23ece1da41bcb48ee217e92ce1579b76741f2d456dd2d2c35c80eefdad9"
    sha256 arm64_linux:   "0b3934f11b431c089878be3263c8a26e86e25ab5fd5b138eb4524449ef0657a4"
    sha256 x86_64_linux:  "4a4aba81dfb4883218e0b5f2f9237285f1c1fc7b18bd364c28d4e773a5d658a2"
  end

  head do
    url "https://svn.code.sf.net/p/gwyddion/code/branches/GWYDDION-UNSTABLE"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook-xsl" => :build
    depends_on "gettext" => :build
    depends_on "gobject-introspection" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    depends_on "gtk+3"

    uses_from_macos "libxslt" => :build

    on_macos do
      depends_on "gtk-mac-integration"
    end
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "fftw"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "libpng"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "pango"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_macos do
    # Regenerate autoconf files to avoid flat namespace in library
    # (autoreconf runs gtkdocize, provided by gtk-doc)
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
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
    configure = if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      ENV.append "ACLOCAL_FLAGS", "--system-acdir=#{HOMEBREW_PREFIX}/share/aclocal"
      ENV.append_path "ACLOCAL_PATH", Formula["gettext"].pkgshare/"m4"
      "./autogen.sh"
    else
      system "autoreconf", "--force", "--install", "--verbose" if OS.mac?
      "./configure"
    end

    args = %W[
      --disable-desktop-file-update
      --disable-pygwy
      --disable-silent-rules
      --with-html-dir=#{doc}
      --without-gtksourceview
    ]

    system configure, *args, *std_configure_args
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
