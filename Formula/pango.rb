class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "http://www.pango.org/"
  url "https://download.gnome.org/sources/pango/1.40/pango-1.40.2.tar.xz"
  sha256 "90582a02bc89318d205814fc097f2e9dd164d26da5f27c53ea42d583b34c3cd1"

  bottle do
    sha256 "6cd2ed1a151427b22872bfc91bbaea3e3c2d2be6edfcd3cb80a8f89fc1d4ef94" => :sierra
    sha256 "d9887de9718b68b250ba0fcdf653dd70b1c390629307c226d51292ed2e0746ba" => :el_capitan
    sha256 "861f6ad2e6c8c06b7072a238dca831cbf5a09eb9125a015150f3d522dbe7d7a7" => :yosemite
    sha256 "1e9be870617caba7603eb1b8953eed684a863035ae2becabe0dd86b9f96a540a" => :mavericks
  end
  
  # upstream bug report - https://bugzilla.gnome.org/show_bug.cgi?id=770729
  patch :p1, :DATA

  head do
    url "https://git.gnome.org/browse/pango.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gtk-doc" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "cairo"
  depends_on "harfbuzz"
  depends_on "fontconfig"
  depends_on "gobject-introspection"

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-man
      --with-html-dir=#{share}/doc
      --enable-introspection=yes
      --without-xft
      --enable-static
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pango-view", "--version"
    (testpath/"test.c").write <<-EOS.undent
      #include <pango/pangocairo.h>

      int main(int argc, char *argv[]) {
        PangoFontMap *fontmap;
        int n_families;
        PangoFontFamily **families;
        fontmap = pango_cairo_font_map_get_default();
        pango_font_map_list_families (fontmap, &families, &n_families);
        g_free(families);
        return 0;
      }
    EOS
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/pango-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{cairo.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lcairo
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/pango/pangocoretext-fontmap.c b/pango/pangocoretext-fontmap.c
index 0d7d793..05d1fd0 100644
--- a/pango/pangocoretext-fontmap.c
+++ b/pango/pangocoretext-fontmap.c
@@ -110,8 +110,8 @@ typedef struct
     PangoWeight pango_weight;
 } PangoCTWeight;

-const float ct_weight_min = -0.7f;
-const float ct_weight_max = 0.8f;
+#define ct_weight_min -0.7
+#define ct_weight_max 0.8

 /* This map is based on empirical data from analyzing a large collection of
  * fonts and comparing the opentype value with the value that OSX returns.

