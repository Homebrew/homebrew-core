class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pango/1.48/pango-1.48.2.tar.xz"
  sha256 "d21f8b30dc8abdfc55de25656ecb88dc1105eeeb315e5e2a980dcef8010c2c80"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "11cb7837397d8a8a5281c2206000fd3a2fdeb09a695eb2fd4018c727344237d7"
    sha256 cellar: :any, big_sur:       "c6fc514ae39aa3825f98bc47b5a02a3e1393f307038aed0933e9f90612532def"
    sha256 cellar: :any, catalina:      "29a36a8c3c7832a48e012e311dc18ef084312000bedbb83d2e09eb914d4b0d71"
    sha256 cellar: :any, mojave:        "2f989c1122baf8e9df2b0c16e3d13cea21fffade426626b301b2ff867ffb7626"
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
