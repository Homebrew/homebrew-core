class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://pango.gnome.org"
  url "https://download.gnome.org/sources/pango/1.52/pango-1.52.1.tar.xz"
  sha256 "58728a0a2d86f60761208df9493033d18ecb2497abac80ee1a274ad0c6e55f0f"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "df797f424c3ae5ad9d75c0149019e9fd82d090b1258f84afe26e3cf5de852006"
    sha256 cellar: :any, arm64_ventura:  "70226b82bef64506c177193a648f6cdcc15ab1151d3fba26ce5347645a6121f1"
    sha256 cellar: :any, arm64_monterey: "20040280e25e11549660314cd3cb1749c8b6d557bb03aeb52404c4adf9728031"
    sha256 cellar: :any, sonoma:         "adc1b0fbe9435b2122200cf4d83f43bcd6b5397117502afc204974ecb6c663d6"
    sha256 cellar: :any, ventura:        "9b312d09052f46ec9185d8ba88f0b231f77fe82d51a5b198b13205cc6d2f59fe"
    sha256 cellar: :any, monterey:       "2f55ac2d21a436ac7a953040086c8657b7b2d90b366b96ad2b2f209b9e4bdeb8"
    sha256               x86_64_linux:   "17133f5511a22498ca3edb3200a5f83511780f9ffd02e9532b499dd1151da413"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "glib"
  depends_on "harfbuzz"

  def install
    system "meson", *std_meson_args, "build",
                    "-Ddefault_library=both",
                    "-Dintrospection=enabled",
                    "-Dfontconfig=enabled",
                    "-Dcairo=enabled",
                    "-Dfreetype=enabled"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"pango-view", "--version"
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
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
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
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
