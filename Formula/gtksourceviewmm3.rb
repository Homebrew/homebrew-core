class Gtksourceviewmm3 < Formula
  desc "C++ bindings for gtksourceview3"
  homepage "https://developer.gnome.org/gtksourceviewmm/"
  url "https://download.gnome.org/sources/gtksourceviewmm/3.18/gtksourceviewmm-3.18.0.tar.xz"
  sha256 "51081ae3d37975dae33d3f6a40621d85cb68f4b36ae3835eec1513482aacfb39"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "fd3d1d483f70e0d450a51062f6212a98f0b25025e6133995f09f3c7b32af7362" => :mojave
    sha256 "20a1a1c428802f8db9137f4f6c5312285f309da870ad442c4b40c0f6665a6489" => :high_sierra
    sha256 "754836affbefee5bb1e305ebb049f89109d083ae2367e69c0a5111d5c9220d26" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gtkmm3"
  depends_on "gtksourceview3"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtksourceviewmm.h>

      int main(int argc, char *argv[]) {
        Gsv::init();
        return 0;
      }
    EOS
    ENV.libxml2
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
    gtkx3 = Formula["gtk+3"]
    gtkmm3 = Formula["gtkmm3"]
    gtksourceview3 = Formula["gtksourceview3"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
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
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/giomm-2.4
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/giomm-2.4/include
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{gtkmm3.opt_include}/gdkmm-3.0
      -I#{gtkmm3.opt_include}/gtkmm-3.0
      -I#{gtkmm3.opt_lib}/gdkmm-3.0/include
      -I#{gtkmm3.opt_lib}/gtkmm-3.0/include
      -I#{gtksourceview3.opt_include}/gtksourceview-3.0
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{gtkx3.opt_include}/gtk-3.0/unix-print
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gtksourceviewmm-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/gtksourceviewmm-3.0/include
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
      -L#{gtkmm3.opt_lib}
      -L#{gtksourceview3.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -L#{pangomm.opt_lib}
      -latk-1.0
      -latkmm-1.6
      -lcairo
      -lcairo-gobject
      -lcairomm-1.0
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgdkmm-3.0
      -lgio-2.0
      -lgiomm-2.4
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lgtk-3
      -lgtkmm-3.0
      -lgtksourceview-3.0
      -lgtksourceviewmm-3.0
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
