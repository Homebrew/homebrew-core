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
    rebuild 1
    sha256 arm64_golden_gate: "0e98c179fbc6b04f19fda239c020380d532d13a3c75afb18efacc38cdc581372"
    sha256 arm64_tahoe:       "4eb0ec4c6d67cc4fb1ccf43a7d59e94b411cfccb485521a30b2209e8b0d38eee"
    sha256 arm64_sequoia:     "20b1a41d80218345defef9ab299277dccdf2e49f127d710d9919ef795ff9eff2"
    sha256 arm64_linux:       "ea90ad30db6da25be39eac715197cf5937914306cf8812bed4fb61a5a54fe3ab"
    sha256 x86_64_linux:      "d1bd85a414c63f04bf18bf24ed6b07f26bf54e169cd6d71e1a691bf892e0904a"
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

  # Can be undeprecated if gwyddion 4.x is released. Can also consider shipping
  # the unstable 3.x series if sufficiently usable around disable time.
  deprecate! date: "2026-08-28", because: "needs EOL `gtk+`"
  disable! date: "2027-08-28", because: "needs EOL `gtk+`"

  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "fftw"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "libpng"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "pango"
  depends_on "webp"
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
