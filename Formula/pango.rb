class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.pango.org/"
  license "GPL-2.0"

  stable do
    url "https://download.gnome.org/sources/pango/1.44/pango-1.44.7.tar.xz"
    sha256 "66a5b6cc13db73efed67b8e933584509f8ddb7b10a8a40c3850ca4a985ea1b1f"

    # Adopts an upstream patch to fix compilers that are picky about
    # fallthrough (e.g., newer clang).
    # Can be removed on the next release.
    patch do
      url "https://gitlab.gnome.org/GNOME/pango/-/commit/0b3cd20be5249c51ec981a66c07a39d54d1d1c9d.patch"
      sha256 "252378845c5b1b09bf5ae1e06200bba7bf3d4bd679aff2888e95233cf8762a76"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "edc52d68cc6ccf07f5e7d7f183bfb2a8752e1d2210537a35ec5afa00925d237a" => :catalina
    sha256 "21fdc9a528fbb0aaa018edcfbbea8de9bdcd68d2b067b16c56cc1abd5cf23a73" => :mojave
    sha256 "bc15d893f34878dbc0f75f3d24e4b3d9e3f2884ffb8e81c5d484541c9ec2354c" => :high_sierra
  end

  head do
    url "https://gitlab.gnome.org/GNOME/pango.git"
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
