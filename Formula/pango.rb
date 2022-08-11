class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://pango.gnome.org"
  url "https://download.gnome.org/sources/pango/1.50/pango-1.50.9.tar.xz"
  sha256 "1b636aabf905130d806372136f5e137b6a27f26d47defd9240bf444f6a4fe610"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "0987ece4f69d550c87ae90bb3f654dc98aed7de627c94b50faf7065f112a25ca"
    sha256 cellar: :any, arm64_big_sur:  "2c4c85f58ee32b3290427b0571dedf0e93603392ea054fb72c3cb513f64fb914"
    sha256 cellar: :any, monterey:       "26cf4351e74e23a737fe41c0c37de0fd86129a9b10142844ec16d3c5f6ac320b"
    sha256 cellar: :any, big_sur:        "e73720950495b7558b147c44580a405580f301c85aa4b717f8473d08e712d347"
    sha256 cellar: :any, catalina:       "31bcb260b96160f6b6d281acdfc68312651b062a6e7d6874944fc83810bd3fe7"
    sha256               x86_64_linux:   "3fe3557945828082262b97d82f49c25c354e5cefbe9d538034bf6585fd2258b1"
  end

  depends_on "glib-utils" => :build
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
