class Gedit < Formula
  desc "The GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/3.30/gedit-3.30.2.tar.xz"
  sha256 "eaf3b17856a0fb7c6f363c2ebbf4f26c5be6eb6552a49e58c44aee0fcb789163"

  bottle do
    sha256 "14c51fd7413b03c98f4f44d22c5218266a27c662f4df9e74b3206aa4a6f72e1a" => :mojave
    sha256 "a4d83117fd6c3b2b5a2d240fd3aa774c3ce830df09143b14f2b2dda566565d3a" => :high_sierra
    sha256 "fde3d49600a69e62507ed9b6fc49771fcbf431eb6ee348c43be12847fc067669" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtk-mac-integration"
  depends_on "gtksourceview3"
  depends_on "iso-codes"
  depends_on "libpeas"
  depends_on "libxml2"
  depends_on "pango"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-updater",
                          "--disable-schemas-compile",
                          "--disable-python"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    # main executable test
    system bin/"gedit", "--version"
    # API test
    (testpath/"test.c").write <<~EOS
      #include <gedit/gedit-utils.h>

      int main(int argc, char *argv[]) {
        gchar *text = gedit_utils_make_valid_utf8("test text");
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
    gobject_introspection = Formula["gobject-introspection"]
    gtkx3 = Formula["gtk+3"]
    gtksourceview3 = Formula["gtksourceview3"]
    libepoxy = Formula["libepoxy"]
    libffi = Formula["libffi"]
    libpeas = Formula["libpeas"]
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
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{gtksourceview3.opt_include}/gtksourceview-3.0
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{include}/gedit-3.14
      -I#{libepoxy.opt_include}
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -I#{libpeas.opt_include}/libpeas-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{lib}/gedit
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{gtksourceview3.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{libpeas.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgedit
      -lgio-2.0
      -lgirepository-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgtk-3
      -lgtksourceview-3.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lpeas-1.0
      -lpeas-gtk-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
