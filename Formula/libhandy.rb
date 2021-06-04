class Libhandy < Formula
  desc "Building blocks for modern adaptive GNOME apps"
  homepage "https://gitlab.gnome.org/GNOME/libhandy"
  url "https://gitlab.gnome.org/GNOME/libhandy/-/archive/1.2.2/libhandy-1.2.2.tar.gz"
  sha256 "006c1d7285602065a8c442227dba84efc74fe028f06bf8a43c1bfdb0b04959ad"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "77d84c76983108e91ac0c046c015a849effb0050ad6301f5a1f1a295512f9772"
    sha256 big_sur:       "d8f5de54f43a158e7cd1e722cfb66d27e20ba73d149e19216960fbfd63956dd3"
    sha256 catalina:      "d1091de69a0bb535fd94ec47cf46f7750aa77fa7ce9b5c955a3d552336156b39"
    sha256 mojave:        "880084f90ca3cd8023c79ec1d511b0a7f4ef585a8ef61464bd79a757add25abc"
  end

  # NOTE: The glade catalog is disabled due to a bug that has been fixed but
  # not landed in a stable libhandy version yet (as of September 2020).
  # See https://gitlab.gnome.org/GNOME/libhandy/-/merge_requests/614
  # When it lands, -Dglade_catalog=enabled should work (make sure to add
  # glade to the dependencies)

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
      -lgtk-3.0
      -lhandy-1
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
