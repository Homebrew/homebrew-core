class Libchamplain < Formula
  desc "ClutterActor for displaying maps"
  homepage "https://wiki.gnome.org/Projects/libchamplain"
  url "https://download.gnome.org/sources/libchamplain/0.12/libchamplain-0.12.16.tar.xz"
  sha256 "4a7e31cf7889669aebf04631543af64435edd989685159b804911c6005db908d"
  revision 1

  bottle do
    sha256 "84d118001a88dda76ad4230ac7e439faff52d15927ae35256203224513cfa5a8" => :mojave
    sha256 "f6164d934f20edac3cce56807031c6398ab4135ac2d1de189fa507d53646d4fe" => :high_sierra
    sha256 "4cd4422e4ea30fb60d77bee37e96d2a221cf78d5cfbb56c7bd4ddff503dd9e63" => :sierra
    sha256 "77dc11f2f53f414fb94db5a48c60827eeda2d54f296a6608aface2d7d7adcba2" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "clutter"
  depends_on "clutter-gtk"
  depends_on "gtk+3"
  depends_on "libsoup"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <champlain/champlain.h>

      int main(int argc, char *argv[]) {
        GType type = champlain_license_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
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
    harfbuzz = Formula["harfbuzz"]
    json_glib = Formula["json-glib"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    libsoup = Formula["libsoup"]
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
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libchamplain-0.12
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{clutter.opt_lib}
      -L#{cogl.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lchamplain-0.12
      -lclutter-1.0
      -lcogl
      -lcogl-pango
      -lcogl-path
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
