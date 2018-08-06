class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pango/1.42/pango-1.42.3.tar.xz"
  sha256 "fb3d875305d5143f02cde5c72fec3903e60dc35844759dc14b2df4955b5dde3a"

  bottle do
    sha256 "49c20497b7779559877d1d9ba6e60bb479d305c09a6301b832f7eba404dcee6e" => :high_sierra
    sha256 "3906e3e45e7784e9ec4c2be43b39005770d68534001a0cb2f8625bfe38a325cc" => :sierra
    sha256 "6affe3058a7a77093ce2054dca9f2dfbd538222d12f6dff88e829ce588e25200" => :el_capitan
  end

  head do
    url "https://gitlab.gnome.org/GNOME/pango.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gtk-doc" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fribidi"
  depends_on "fontconfig"
  depends_on "glib"
  depends_on "harfbuzz"

  # This fixes a font-size problem in gtk
  # For discussion, see https://bugzilla.gnome.org/show_bug.cgi?id=787867
  patch do
    url "https://gitlab.gnome.org/tschoonj/pango/commit/60df2b006e5d4553abc7bb5fe9a99539c91b0022.patch"
    sha256 "d5ece753cf393ef507dd2b0415721b4381159da5e2f40793c6d85741b1b163bc"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-html-dir=#{share}/doc",
                          "--enable-introspection=yes",
                          "--enable-static",
                          "--without-xft"

    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pango-view", "--version"
    (testpath/"test.c").write <<~EOS
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
