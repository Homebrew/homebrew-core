class Gtkextra < Formula
  desc "Widgets for creating GUIs for GTK+"
  homepage "https://gtkextra.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gtkextra/3.3/gtkextra-3.3.4.tar.gz"
  sha256 "651b738a78edbd5d6ccb64f5a256c39ec35fbbed898e54a3ab7e6cf8fd82f1d6"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "c38010856fc21985142ce72c0b07be8aba4d8b2d24e7a29fee497383d131efbc" => :mojave
    sha256 "a18ed1a1fe359d9572ac5f334b522b175c0309168dbe1274f25884f9d062282e" => :high_sierra
    sha256 "021592c075825331cf707f79c010fa75f1e688f821acfe167543236f8cdcc556" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-tests",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtkextra/gtkextra.h>
      int main(int argc, char *argv[]) {
        GtkWidget *canvas = gtk_plot_canvas_new(GTK_PLOT_A4_H, GTK_PLOT_A4_W, 0.8);
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
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gtkextra-3.0
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
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lgtkextra-quartz-3.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
