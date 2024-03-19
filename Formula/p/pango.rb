class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://pango.gnome.org"
  url "https://download.gnome.org/sources/pango/1.52/pango-1.52.1.tar.xz"
  sha256 "58728a0a2d86f60761208df9493033d18ecb2497abac80ee1a274ad0c6e55f0f"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1fa9229d709fe3f575114d060f7726db26a8ab8f9ab058f7d2f042e666e6ae95"
    sha256 cellar: :any, arm64_ventura:  "d86c67fd39afb1e3fbe9b803d9107dd536c0b5086a4160ae859068a21c71f172"
    sha256 cellar: :any, arm64_monterey: "3b30a0c3a058ffe6977e16ee7a404d8a17552040485cd28b6c6a5754de3cdcc4"
    sha256 cellar: :any, sonoma:         "c78f6d24d9d5e77f52dfee940d28b94d1987274c7808b1080b6122003f09af98"
    sha256 cellar: :any, ventura:        "e8ab71a94c437c0d7a5b682ea57dc2924df49dc43a308743a35b36931ce9f475"
    sha256 cellar: :any, monterey:       "15c47e94ebf216583c4501d9f67598fed1f2e30643f5b2d1c98a59ef87bcd849"
    sha256               x86_64_linux:   "02b153ece2669b530ea6b9f0931ce0efb754a5d2f772755fb5a39d93f0c77ee0"
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
