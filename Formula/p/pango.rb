class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://pango.gnome.org"
  url "https://download.gnome.org/sources/pango/1.52/pango-1.52.2.tar.xz"
  sha256 "d0076afe01082814b853deec99f9349ece5f2ce83908b8e58ff736b41f78a96b"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d7310d07a8e4de1846e72e1965012b706df6b6b68b7d7044d0b626927dd0dbda"
    sha256 cellar: :any, arm64_ventura:  "70afddfad7b00656b7220b029d06d74097a0db1d5d7989157240e8b3c20ec383"
    sha256 cellar: :any, arm64_monterey: "beb7df52397c4bf1d05384f41878938fb1bf582a73cc02ee91ffda6595b7d4fd"
    sha256 cellar: :any, sonoma:         "c444b645580247700e28bd354648b317eb63f7f6bf2baae0f098911056b0f7a1"
    sha256 cellar: :any, ventura:        "a4f074c18620090f87aa15b1879126cf9cb2f5ddaaa2c0b54e2fd17cd591485d"
    sha256 cellar: :any, monterey:       "fb4cfb5fb199236e438b2da4ad85d510b0c64434c65060fbef6a74140ba651b2"
    sha256               x86_64_linux:   "1cd2f38a7df814a3153d1d9904fa9de169621d35a70a38507879fa101010e44f"
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
