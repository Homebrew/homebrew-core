class Libhandy < Formula
  desc "Building blocks for modern adaptive GNOME apps"
  homepage "https://gitlab.gnome.org/GNOME/libhandy"
  url "https://gitlab.gnome.org/GNOME/libhandy/-/archive/1.8.0/libhandy-1.8.0.tar.gz"
  sha256 "34bafc4ed57401bf0c18be85b06d38fc274fe5858db5eeee9c28b67a07d762da"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "2e2205fcb369590d99bf1244dd7dda9030b45089a910abf47b6c1a04db09c7f0"
    sha256 arm64_big_sur:  "89a7fa9f2395dff4d99c67eaf9bfb032724179d7971fbe4e31e813b1ba865f32"
    sha256 monterey:       "2b166e8d56b1c339b9646d58a1155342fa9ecda16c6a364e7abc5d8c4e6df446"
    sha256 big_sur:        "5e664307f41f5e7bcfe076770b93736cd6f6e1a78fb7c3a501c9889b1f0cb166"
    sha256 catalina:       "32f2f6643c7ab5648997a2f2d43f017d72d53abf42afad5db5acb1a33c75249a"
    sha256 x86_64_linux:   "73032904b4bb9d851aca2081de2bf18603089c8c34c6e033ca7f7ea623762b60"
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
