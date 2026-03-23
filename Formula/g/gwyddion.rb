class Gwyddion < Formula
  desc "Scanning Probe Microscopy visualization and analysis tool"
  homepage "https://gwyddion.net/"
  license "GPL-2.0-or-later"

  stable do
    url "https://downloads.sourceforge.net/project/gwyddion/gwyddion/2.70/gwyddion-2.70.tar.xz"
    sha256 "942f4e041945a850bc32d05193a115ac8a5118a6f841afa6d4dea510f9913f59"

    depends_on "gtk+"
  end

  livecheck do
    url "https://gwyddion.net/download.php"
    regex(/stable\s+version\s+Gwyddion\s+v?(\d+(?:\.\d+)+)[:<\s]/im)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "4600005e4a74dc2e9b3e0ec17f9e0e52c5cdebeaf4830f16e187d2b06415b44b"
    sha256 arm64_sequoia: "f95d7836e09dfc7cdc666fd93d7125734d4b07fec1308b9c01cb3a7a875265b1"
    sha256 arm64_sonoma:  "3c532cc85266974f4af9ba3f04b971ba1116f7a763dd9a9b9fa373033971225c"
    sha256 sonoma:        "960dbce3c3045c936ec5bcbda40626a20664b2e8540224211e573b2784569cd4"
    sha256 arm64_linux:   "799e34fbff79d604bdf29e5ba6e91e68466ea8ce4c208631021f73d9e0822175"
    sha256 x86_64_linux:  "d9f991bd16d1e0e3412b2f61c9d6a6b8806c8db047482381a4f77f951294dd1f"
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
