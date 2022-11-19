class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://pango.gnome.org"
  url "https://download.gnome.org/sources/pango/1.50/pango-1.50.12.tar.xz"
  sha256 "caef96d27bbe792a6be92727c73468d832b13da57c8071ef79b9df69ee058fe3"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "51b7e3860cd156895f0490cc129b566a1651aff7f7cce73c323696848ae20023"
    sha256 cellar: :any, arm64_monterey: "7dc6606472b236915266dfb94c50f28f5861b52ef99f56d4d72a2227258872a0"
    sha256 cellar: :any, arm64_big_sur:  "56c1e63e58b97e32da1f37f2db2433b9c5658d097bb3d92911821ca97fd7ecab"
    sha256 cellar: :any, ventura:        "ab5f532dbd4d3bb1fd639c11e8209491bbff430d20db66b108496dfa13ff1bfb"
    sha256 cellar: :any, monterey:       "8c06a68283a051294430d1d21b69488f5bfc9e75d4517c5edfb0cce50c85c0b3"
    sha256 cellar: :any, big_sur:        "c33f8819693d365cff97fa9fb2cfebb8ee0d61421e28625b817b8e33b80c569a"
    sha256 cellar: :any, catalina:       "80e859a35cd76f439534fc3d33b983d90662cef6d94abc0ccb06177e144ac4dd"
    sha256               x86_64_linux:   "b9c7127cc6d731fbedf6cb96c67b6ab1997b00965fcc8485375fa499e5659cf9"
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
