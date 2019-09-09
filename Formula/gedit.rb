class Gedit < Formula
  desc "The GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/3.34/gedit-3.34.0.tar.xz"
  sha256 "3e95e51d3ccb495a9ac95aa3ed7fe8fe37ccde7c678f37fa3cea684bc71d507e"

  bottle do
    rebuild 1
    sha256 "fe9fe788f16e01155e292c3320a9ebec63618862c5fcfe3531672264d66c6177" => :mojave
    sha256 "7e463e2775781d23ee8406343fa89caba8238c2427a1c76882a451c22dfda902" => :high_sierra
    sha256 "b254f20c17f8f9cc8b1bc883c4e1ac398ec87742997a68e7b925be735734137c" => :sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
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
  depends_on "gtksourceview4"
  depends_on "libpeas"
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "pango"

  def install
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-qtf", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
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
    gtksourceview4 = Formula["gtksourceview4"]
    harfbuzz = Formula["harfbuzz"]
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
      -I#{gtksourceview4.opt_include}/gtksourceview-4
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
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
      -L#{gtksourceview4.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{libpeas.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgedit-3.14
      -lgio-2.0
      -lgirepository-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgtk-3
      -lgtksourceview-4.0
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
