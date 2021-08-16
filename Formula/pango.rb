class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pango/1.48/pango-1.48.8.tar.xz"
  sha256 "009d9d830ecbe11911d6637e48eec1c51390d3d12eb286035ef7c641f3c87410"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b9cc364fb9d52b2be2387e652c6ec020a04a0a80928098a1fe14511329241192"
    sha256 cellar: :any, big_sur:       "1f059beee989558f8a6ec2cf8744c542e222ed48c68549176d6518a56ac45ddd"
    sha256 cellar: :any, catalina:      "07f944aa3ba4b8dcad55b856d74daa3386876cb8683f74e895ed78fc588405cd"
    sha256 cellar: :any, mojave:        "996df99f45656cc9c741a306d381f1f5ef63c8ec0859299f64b81ec6055d6127"
    sha256               x86_64_linux:  "74d3a3a79960c3c2e7aca70bbdf0c83d16f47465352b3d152e3d031ffbef1733"
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
                      "-Dintrospection=enabled",
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
