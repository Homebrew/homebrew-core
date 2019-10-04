class Libdazzle < Formula
  desc "GNOME companion library to GObject and Gtk+"
  homepage "https://gitlab.gnome.org/GNOME/libdazzle"
  url "https://download.gnome.org/sources/libdazzle/3.34/libdazzle-3.34.0.tar.xz"
  sha256 "8d8524bcb2acd6bda0fb3efe96f0bf3e8860ca18eed1fc55dc1c27756b49637c"
  revision 1

  bottle do
    cellar :any
    sha256 "659df8d399e3ff0e90a550544b6813c43bad88e255dc32e9b7f3b65084a5e30a" => :mojave
    sha256 "09c75b49bd517178b665d55123e4c3c49897f7b0e79a5d2ac5efb6292a354583" => :high_sierra
    sha256 "4882455bb709917b7ef5f8e39b563a12d42067ba3699ead4811e58d8ca2f1966" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dwith_vapi=true", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <dazzle.h>

      int main(int argc, char *argv[]) {
        g_assert_false(dzl_file_manager_show(NULL, NULL));
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
    graphite2 = Formula["graphite2"]
    gtkx3 = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pcre = Formula["pcre"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{graphite2.opt_include}
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libdazzle-1.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pcre.opt_include}
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -ldazzle-1.0
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -Wl,-framework
      -Wl,CoreFoundation
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
