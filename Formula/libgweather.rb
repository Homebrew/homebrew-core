class Libgweather < Formula
  desc "GNOME library for weather, locations and timezones"
  homepage "https://wiki.gnome.org/Projects/LibGWeather"
  url "https://download.gnome.org/sources/libgweather/3.20/libgweather-3.20.1.tar.xz"
  sha256 "81eb829fab6375cc9a4d448ae0f790e48f9720e91eb74678b22264cfbc8938d0"

  bottle do
    sha256 "3d9010f144e6ea66b00c5d4b492e7e8a67435f0b2b2dd5bbac25490eac088e54" => :sierra
    sha256 "b6bddc8ca66e33ca7ff10d57038d37b0eb674bcdf0ddffb5581a50cd1db19465" => :el_capitan
    sha256 "29ca26ee32e81a2c12c1c7b52cd1695bad1e20e8702bbdb123651ff8430a4ff5" => :yosemite
    sha256 "e8325e2c5d6b2c90dfd28ea294a95220ce62577a1b97f7234ed037a6702bbc79" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gtk+3"
  depends_on "geocode-glib"
  depends_on "libsoup"
  depends_on "gobject-introspection"
  depends_on "vala" => :optional

  def install
    # ensures that the vala files remain within the keg
    inreplace "libgweather/Makefile.in",
              "VAPIGEN_VAPIDIR = @VAPIGEN_VAPIDIR@",
              "VAPIGEN_VAPIDIR = @datadir@/vala/vapi"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libgweather/gweather.h>

      int main(int argc, char *argv[]) {
        GType type = gweather_info_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    libsoup = Formula["libsoup"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{include}/libgweather-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{pango.opt_include}/pango-1.0
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
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lgweather-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "-DGWEATHER_I_KNOW_THIS_IS_UNSTABLE=1", "test.c", "-o", "test", *flags
    system "./test"
  end
end
