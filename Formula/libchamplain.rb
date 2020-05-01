class Libchamplain < Formula
  desc "ClutterActor for displaying maps"
  homepage "https://wiki.gnome.org/Projects/libchamplain"
  url "https://download.gnome.org/sources/libchamplain/0.12/libchamplain-0.12.20.tar.xz"
  sha256 "0232b4bfcd130a1c5bda7b6aec266bf2d06e701e8093df1886f1e26bc1ba3066"

  bottle do
    cellar :any
    sha256 "b6be73601f13ea2e273909b9946071e1904ef379d1b001366f347d78b5a8643c" => :catalina
    sha256 "9722cf78615bca8249d01e0df046ac75cfa056afe66fdf88eadbb4cc442a9665" => :mojave
    sha256 "0ab75bc1d716f572c0eeef649f8bbdd390e87debb519faa6e350d02646139b09" => :high_sierra
  end

  depends_on "gnome-common" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "clutter"
  depends_on "clutter-gtk"
  depends_on "gtk+3"
  depends_on "libsoup"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Ddocs=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <champlain/champlain.h>

      int main(int argc, char *argv[]) {
        GType type = champlain_license_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    clutter = Formula["clutter"]
    cogl = Formula["cogl"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    json_glib = Formula["json-glib"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    libsoup = Formula["libsoup"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{clutter.opt_include}/clutter-1.0
      -I#{cogl.opt_include}/cogl
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/champlain-0.12
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{clutter.opt_lib}
      -L#{cogl.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lchamplain-0.12
      -lclutter-1.0
      -lcogl
      -lcogl-pango
      -lcogl-path
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
