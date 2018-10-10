class Gtkspell3 < Formula
  desc "Gtk widget for highlighting and replacing misspelled words"
  homepage "https://gtkspell.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gtkspell/3.0.10/gtkspell3-3.0.10.tar.xz"
  sha256 "b040f63836b347eb344f5542443dc254621805072f7141d49c067ecb5a375732"

  bottle do
    sha256 "7c52aea6699ea8f9eb0e67f78d53ae2efc71c7f7e599985c678188e1cb1dbc0e" => :mojave
    sha256 "ab277eb4f040f5032fdcf73dc1c7ba270398753c2e0c1cd994df348226bc0740" => :high_sierra
    sha256 "faf983f8d91c4419199e27a3ccb49c8427b4d51d488cf1734c7db6b3f39f72b3" => :sierra
    sha256 "63b6f8d3dc5fc4b01348f91b79013ff3db1b834163c93476609dfd13e6e0930f" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "enchant"
  depends_on "gtk+3"

  def install
    system "autoreconf", "-fi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--enable-vala",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtkspell/gtkspell.h>

      int main(int argc, char *argv[]) {
        GList *list = gtk_spell_checker_get_language_list();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    enchant = Formula["enchant"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{enchant.opt_include}/enchant-2
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{include}/gtkspell-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{enchant.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lenchant-2
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgtk-3
      -lgtkspell3-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
