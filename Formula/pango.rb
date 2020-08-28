class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pango/1.46/pango-1.46.1.tar.xz"
  sha256 "fe516b10711bbb6fd75011d66dd08fabfce18f7931aed7415136d53c4aadf1c5"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "ddf6c6e74e58909336517fdad64ff0f32212627b1fae8d9bb53439953d29279a" => :catalina
    sha256 "cbf05eae84754034359bfed76853667eaf1b53bfaa92f2da67c416299e17e6c7" => :mojave
    sha256 "de0f7b7a6c735a240feb38c00c66afc99316e1d82432b677f4de3fef076cbb89" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "glib"
  depends_on "harfbuzz"

  def install
    mkdir "build" do
      system "meson", *std_meson_args,
                      "-Ddefault_library=both",
                      "-Dintrospection=true",
                      "-Duse_fontconfig=true",
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
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
