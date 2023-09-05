class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://pango.gnome.org"
  url "https://download.gnome.org/sources/pango/1.50/pango-1.50.14.tar.xz"
  sha256 "1d67f205bfc318c27a29cfdfb6828568df566795df0cb51d2189cde7f2d581e8"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "36b5b69c52886ea5c6599bc35bf22eb942cc44b2bcbe2ea0bd2340d72fe1d832"
    sha256 cellar: :any, arm64_monterey: "0aaa4549f79b4fcd445fcfa409a516e5d1058b41853a056b191c43ad3388d959"
    sha256 cellar: :any, arm64_big_sur:  "34d3bddaee4e322f64cb8a65763702d0037dd65f100772665b71a0ac108708d0"
    sha256 cellar: :any, ventura:        "eae13498d195f5407514f88c3681981e4cf8b1b3099af13ce771be9934929ead"
    sha256 cellar: :any, monterey:       "34449966361af6e0ec7808fc48ea6b6368fb56c9873b332c77740a9ed4d0fdc1"
    sha256 cellar: :any, big_sur:        "8058dda295f5bd9a7fa01124a22b850285363fc9ab65e644bb037ad621475eb3"
    sha256               x86_64_linux:   "c0e091a6c225b78ca16eef4dd0d955a13996c44896a6ee5d182aef5944f59cc8"
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
