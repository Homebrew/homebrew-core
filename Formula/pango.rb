class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "http://www.pango.org/"
  url "https://download.gnome.org/sources/pango/1.40/pango-1.40.1.tar.xz"
  sha256 "e27af54172c72b3ac6be53c9a4c67053e16c905e02addcf3a603ceb2005c1a40"

  bottle do
    sha256 "36326c6d7abc459041dfbb0e0aecda5b82af131758f5d2f3219bb44b7fd13a8f" => :el_capitan
    sha256 "611ca9423895581fd4fb5c447a83bf46c71b41daecfaab3281c479d84639f770" => :yosemite
    sha256 "2309a2038eaba4d2501146b3fb2a11a2404d0c620e022fdcc87f39fdbd763f9b" => :mavericks
  end

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
