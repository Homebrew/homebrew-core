class ClutterGtk < Formula
  desc "GTK+ integration library for Clutter"
  homepage "https://wiki.gnome.org/Projects/Clutter"
  url "https://download.gnome.org/sources/clutter-gtk/1.8/clutter-gtk-1.8.4.tar.xz"
  sha256 "521493ec038973c77edcb8bc5eac23eed41645117894aaee7300b2487cb42b06"
  revision 1

  bottle do
    sha256 "6e59404c7b4172bfb03b701bd7090dd3c9e917a1f3013e5669a05704369add8a" => :mojave
    sha256 "20e4d6eafb36559b56406f5e26e8989d7d636945cabe9f6d4aa29a1661e46500" => :high_sierra
    sha256 "2b0b873bc1f679f76216ee07ebc79fa0dffb8a0be3f7239868141f342e2a700e" => :sierra
    sha256 "ce3e5e2f2a6107b17b521812fe7ab985e8d6e1cf57b8a3aa84a19cb760809e16" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "clutter"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --enable-introspection=yes
      --disable-silent-rules
      --disable-gtk-doc-html
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <clutter-gtk/clutter-gtk.h>

      int main(int argc, char *argv[]) {
        GOptionGroup *group = gtk_clutter_get_option_group();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    clutter = Formula["clutter"]
    cogl = Formula["cogl"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    json_glib = Formula["json-glib"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{clutter.opt_include}/clutter-1.0
      -I#{cogl.opt_include}/cogl
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{include}/clutter-gtk-1.0
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{clutter.opt_lib}
      -L#{cogl.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lclutter-1.0
      -lclutter-gtk-1.0
      -lcogl
      -lcogl-pango
      -lcogl-path
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgtk-3
      -lintl
      -ljson-glib-1.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
