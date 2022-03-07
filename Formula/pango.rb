class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://pango.gnome.org"
  url "https://download.gnome.org/sources/pango/1.50/pango-1.50.5.tar.xz"
  sha256 "6d136872da6207fe88c5cd2c95c36bcaf4ed29402b854663a86cd7efe99b0cf5"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "b5e081e40a0c39a952be8e912d28d74f4a7a3f4db4b33bdbadbad340b2af836e"
    sha256 cellar: :any, arm64_big_sur:  "a5bd533f40412a4b9f040065b0b1f0d2fe46c89e57b39b0d938c91b0cb125ba4"
    sha256 cellar: :any, monterey:       "c31df18daf1198d322091f6d77c6e6474d4c84b2a125bc1adce540666b5cac0f"
    sha256 cellar: :any, big_sur:        "f6dc158aa9a6e5029b7eacd00a4453a65343d421be50c8acf637c8b7b1ad51ef"
    sha256 cellar: :any, catalina:       "fa79f73d332b1493a664c7144bf3347e1d94dfec57292a29810a577f04b2585f"
    sha256               x86_64_linux:   "4aad9250d37c0f9b845f634c7dc898007c6cf8cc98401bad9bce204983e8fd2c"
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
