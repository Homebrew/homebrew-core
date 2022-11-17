class Libhandy < Formula
  desc "Building blocks for modern adaptive GNOME apps"
  homepage "https://gitlab.gnome.org/GNOME/libhandy"
  url "https://gitlab.gnome.org/GNOME/libhandy/-/archive/1.8.0/libhandy-1.8.0.tar.gz"
  sha256 "34bafc4ed57401bf0c18be85b06d38fc274fe5858db5eeee9c28b67a07d762da"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "c2a5965da71d08b9b31d4df765cbef8268ef3b4b10210cd8164d7164b0b11e15"
    sha256 arm64_monterey: "973506dea8f690558a01f8b4e786c66e785a9dc5fb69347bcf3f501a6bce2b00"
    sha256 arm64_big_sur:  "a3907134a8b5a823a1a591f5aece22e2668503ee6d457100ec7e8985759f8933"
    sha256 ventura:        "f495e7933e16595c07828dfff9f718caa2396250d4b7a96ff70f3f5eb442cd9d"
    sha256 monterey:       "3299684c80ba3fb24bf03061c4086f0b5ba195f26833f251194477ebb9f6271b"
    sha256 big_sur:        "b570dc588fde9e71fe4d65d196de009d968d0ed21931b3c01ff1b286c81cdac3"
    sha256 catalina:       "77f8b6b63595aa9016a59753376a7795335c40b827070a65277a8858d624987e"
    sha256 x86_64_linux:   "75047efa0473ce094e13388d08fefdea2dc44e5c58be89325f959efe9b87b6c5"
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
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    # Don't have X/Wayland in Docker
    system "./test" if OS.mac?
  end
end
