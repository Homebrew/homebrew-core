class Gtef < Formula
  desc "GNOME Text Editor Framework"
  homepage "https://wiki.gnome.org/Projects/Gtef"
  url "https://download.gnome.org/sources/gtef/2.0/gtef-2.0.0.tar.xz"
  sha256 "12fb28b101bc14a7ed266a25e8ff41c0535e1201ce38905e443c8fca83e5ac71"

  bottle do
    sha256 "027cd5f9151a8d73dc61d9708815d02e551010db4a1ff50c41daa484efc617d9" => :sierra
    sha256 "0dc2178d62adbb9ea38515e4e9136f4294e18ee24b832c16fa15275acddec90d" => :el_capitan
    sha256 "7c558cee5794e809d0e5c333e97f3031b7cff702c1e8ed6909687431fb240f88" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :recommended
  depends_on "gtksourceview3"
  depends_on "uchardet"

  def install
    ENV.delete "SDKROOT"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gtef/gtef.h>

      int main(int argc, char *argv[]) {
        GType type = gtef_file_get_type();
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
    gtksourceview3 = Formula["gtksourceview3"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pcre = Formula["pcre"]
    pixman = Formula["pixman"]
    uchardet = Formula["uchardet"]
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
      -I#{gtksourceview3.opt_include}/gtksourceview-3.0
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gtef-2
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pcre.opt_include}
      -I#{pixman.opt_include}/pixman-1
      -I#{uchardet.opt_include}/uchardet
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtksourceview3.opt_lib}
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
      -lgtef-2
      -lgtk-3
      -lgtksourceview-3.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
