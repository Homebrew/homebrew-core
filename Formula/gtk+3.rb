class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.22/gtk+-3.22.19.tar.xz"
  sha256 "9883d3ca5244f9b3168ce660e87d52900e141d0f7147dea0640bdd6fe8e5166c"

  bottle do
    sha256 "d67780b58945ab95d9a2fe472999920568134f704c6b8b73e4c01ad75d7f9a7e" => :sierra
    sha256 "93d6f15da103c2c30a1fe653ed84b17024642846f487a4bc44f752bf281dae63" => :el_capitan
    sha256 "850d0ba5092d2d8ac36ec68ab840767b0acf53a8224bb0f485915822099f7c4b" => :yosemite
  end

  option "with-quartz-relocation", "Build with quartz relocation support"

  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"
  depends_on "atk"
  depends_on "gobject-introspection"
  depends_on "libepoxy"
  depends_on "pango"
  depends_on "glib"
  depends_on "hicolor-icon-theme"
  depends_on "gsettings-desktop-schemas" => :recommended
  depends_on "jasper" => :optional

  def install
    args = %W[
      --enable-debug=minimal
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-glibtest
      --enable-introspection=yes
      --disable-schemas-compile
      --enable-quartz-backend
      --disable-x11-backend
    ]

    args << "--enable-quartz-relocation" if build.with?("quartz-relocation")

    system "./configure", *args
    # necessary to avoid gtk-update-icon-cache not being found during make install
    bin.mkpath
    ENV.prepend_path "PATH", bin
    system "make", "install"
    # Prevent a conflict between this and Gtk+2
    mv bin/"gtk-update-icon-cache", bin/"gtk3-update-icon-cache"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
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
    libepoxy = Formula["libepoxy"]
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
      -I#{include}
      -I#{include}/gtk-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
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
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
