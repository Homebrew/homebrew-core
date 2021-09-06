class Libhandy < Formula
  desc "Building blocks for modern adaptive GNOME apps"
  homepage "https://gitlab.gnome.org/GNOME/libhandy"
  url "https://download.gnome.org/sources/libhandy/1.4/libhandy-1.4.0.tar.xz"
  sha256 "2676d51fa1fa40fdee7497d3e763fefa18b0338bffcd2ee32e7f7e633c885446"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "5d2dbb845cf88133e1ef430f457127b4101534612a8b80b8830dea4e29432439"
    sha256 big_sur:       "a6aa6e6042f4be52b6771e90ca9a35f4792bc8ae3cf0e2a641285ea7c7b6b35b"
    sha256 catalina:      "094c9ab75ad36b5ea16fddebf1280cd7a2a70ffd513a98ba80cae27d540a9d36"
    sha256 mojave:        "e23bf85ef855b2fa9bde7dabc8ef4ae651f0c1d3157ee5578b46a319c9910d47"
    sha256 x86_64_linux:  "62d3bc37a45613506fcb1d93491423a0de7697603815dafc1931c7ef56c0d676"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dglade_catalog=disabled", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>
      #include <handy.h>
      int main(int argc, char *argv[]) {
        gtk_init (&argc, &argv);
        hdy_init ();
        HdyLeaflet *leaflet = HDY_LEAFLET (hdy_leaflet_new ());
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtk = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtk.opt_include}/gtk-3.0
      -I#{gtk.opt_lib}/gtk-3.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libhandy-1
      -I#{libpng.opt_include}/libpng16
      -I#{lib}/libhandy-1/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtk.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lhandy-1
      -lpango-1.0
      -lpangocairo-1.0
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    # Don't have X/Wayland in Docker
    on_macos do
      system "./test"
    end
  end
end
