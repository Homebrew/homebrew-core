class Libgnomecanvas < Formula
  desc "Highlevel, structured graphics library"
  homepage "https://developer.gnome.org/libgnomecanvas/2.30/"
  url "https://download.gnome.org/sources/libgnomecanvas/2.30/libgnomecanvas-2.30.3.tar.bz2"
  sha256 "859b78e08489fce4d5c15c676fec1cd79782f115f516e8ad8bed6abcb8dedd40"
  revision 3

  bottle do
    cellar :any
    sha256 "45cf95b18206ce16aecc6d642d7fe453b3f03a2dd50a2fdfcfb574cf3e428239" => :mojave
    sha256 "91610f96cef0504b4be9fb6355cac9f628867cc3bb6b8833aaad48c583f47dea" => :high_sierra
    sha256 "ed520a02e7ea3cd0bcd48dba1ed262d89921bd5f5518c1d672f43a833c6bd758" => :sierra
    sha256 "b1a71d30655833a45b35af8770181fbe3f5df7e66d1b08f491900d5e875acfef" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"
  depends_on "libart"
  depends_on "libglade"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-static",
                          "--prefix=#{prefix}",
                          "--enable-glade"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libgnomecanvas/libgnomecanvas.h>

      int main(int argc, char *argv[]) {
        GnomeCanvasPoints *gcp = gnome_canvas_points_new(100);
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
    gtkx = Formula["gtk+"]
    harfbuzz = Formula["harfbuzz"]
    libart = Formula["libart"]
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
      -I#{gtkx.opt_include}/gail-1.0
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libgnomecanvas-2.0
      -I#{libart.opt_include}/libart-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{libart.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -lart_lgpl_2
      -latk-1.0
      -lcairo
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgnomecanvas-2
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
