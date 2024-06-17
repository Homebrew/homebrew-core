class Libhandy < Formula
  desc "Building blocks for modern adaptive GNOME apps"
  homepage "https://gitlab.gnome.org/GNOME/libhandy"
  url "https://gitlab.gnome.org/GNOME/libhandy/-/archive/1.8.3/libhandy-1.8.3.tar.gz"
  sha256 "7e7670f5d0a6d0adc24b888da44dab938a6f52472b8944d6dd4e31b6d3569a5f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "f1b399070cea7b5c44e3afad605155f867659920d5d3de17c466cf5cc3ba6a33"
    sha256 arm64_ventura:  "46282e234e80d7e1333fd66978709232ccd69517759099868c386c6eec51ca84"
    sha256 arm64_monterey: "2efac67c62c3b8da9bdb64fb4b37a0c66b184239009feb39d5407431b6f9b4e8"
    sha256 sonoma:         "b7451a9bbf91864a025ac3df2473f9dc91398b22d3994f4cc9907344e9be6f1f"
    sha256 ventura:        "ac6d97fd95891df7ecfa6caf13d15c28c153db6fea7da1dd9aee2e56c4780a59"
    sha256 monterey:       "9b94bd79179daca2b005bdd61ba0f1fcefdcd2b19ab85a9e5732f8c2f0428315"
    sha256 x86_64_linux:   "6b470387d368374a5834bb3a73c2d0fcc4cc16121e785a064913735356581e85"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"

  def install
    system "meson", "setup", "build", "-Dglade_catalog=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
