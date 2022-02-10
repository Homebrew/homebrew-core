class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pango/1.50/pango-1.50.4.tar.xz"
  sha256 "f4ad63e87dc2b145300542a4fb004d07a9f91b34152fae0ddbe50ecdd851c162"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "f22db6d8b168be9f10df5ee7e9d439665dd180a9d05626d16701d313e26a73d3"
    sha256 cellar: :any, arm64_big_sur:  "f5d0068b9b7be1e3f73de3ed5849afb93814dbeddc94c5241c230188b95f00cf"
    sha256 cellar: :any, monterey:       "135a1cdcbc6e705dbe00772c01bbeeb0ea95694b0a3cd76d5c3d30bf4df48d88"
    sha256 cellar: :any, big_sur:        "469f5768ce3ac691dad77b5c4b77d7a9b706883afcc595f2e5f1cf7f7cecd330"
    sha256 cellar: :any, catalina:       "2e50912a0903b1625bb976ecb19e09ab1136f2ccabccebc4427b09a1ed0a4cb4"
    sha256               x86_64_linux:   "d8cf7803c5cca6acd5368a7f8970079f4459b9dfb1acf6087bc77f60ea847521"
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
    mkdir "build" do
      system "meson", *std_meson_args,
                      "-Ddefault_library=both",
                      "-Dintrospection=enabled",
                      "-Dfontconfig=enabled",
                      "-Dcairo=enabled",
                      "-Dfreetype=enabled",
                      ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
