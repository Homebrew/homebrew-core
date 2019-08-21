class Gtkmm < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/2.24/gtkmm-2.24.5.tar.xz"
  sha256 "0680a53b7bf90b4e4bf444d1d89e6df41c777e0bacc96e9c09fc4dd2f5fe6b72"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "a412246e2ce05847b3466b11305a79b8535c893ae5a989c9e0f7205a0f8941e6" => :mojave
    sha256 "a4779405ddf5b86488c8de440f9b94c04e78456d63d066b88651afd6065d6f5a" => :high_sierra
    sha256 "e2bfb4fa780b3e63c5d1d01883d8d9e5267b6eb42df92931adc13150ee43d9e9" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "atkmm"
  depends_on "cairomm"
  depends_on "glibmm"
  depends_on "gtk+"
  depends_on "libsigc++"
  depends_on "pangomm"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtkmm.h>

      int main(int argc, char *argv[]) {
        Gtk::Label label("Hello World!");
        return 0;
      }
    EOS
    atk = Formula["atk"]
    atkmm = Formula["atkmm"]
    cairo = Formula["cairo"]
    cairomm = Formula["cairomm"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    gtkx = Formula["gtk+"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    libsigcxx = Formula["libsigc++"]
    pango = Formula["pango"]
    pangomm = Formula["pangomm"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{atkmm.opt_include}/atkmm-1.6
      -I#{cairo.opt_include}/cairo
      -I#{cairomm.opt_include}/cairomm-1.0
      -I#{cairomm.opt_lib}/cairomm-1.0/include
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/giomm-2.4
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/giomm-2.4/include
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_include}/gtk-unix-print-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gdkmm-2.4
      -I#{include}/gtkmm-2.4
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/gdkmm-2.4/include
      -I#{lib}/gtkmm-2.4/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pangomm.opt_include}/pangomm-1.4
      -I#{pangomm.opt_lib}/pangomm-1.4/include
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{atkmm.opt_lib}
      -L#{cairo.opt_lib}
      -L#{cairomm.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -L#{pangomm.opt_lib}
      -latk-1.0
      -latkmm-1.6
      -lcairo
      -lcairomm-1.0
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgdkmm-2.4
      -lgio-2.0
      -lgiomm-2.4
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lgtkmm-2.4
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lpangomm-1.4
      -lsigc-2.0
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
