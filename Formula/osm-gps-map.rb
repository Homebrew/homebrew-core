class OsmGpsMap < Formula
  desc "GTK+ library to embed OpenStreetMap maps"
  homepage "https://nzjrs.github.com/osm-gps-map/"
  url "https://github.com/nzjrs/osm-gps-map/releases/download/1.1.0/osm-gps-map-1.1.0.tar.gz"
  sha256 "8f2ff865ed9ed9786cc5373c37b341b876958416139d0065ebb785cf88d33586"

  bottle do
    sha256 "4d5e367da76a98493963cb0b5bb50132346a627318e92851faef84b7228ca284" => :sierra
    sha256 "764f9a62335f14db107b7d3e9c5ec0c8bb1d1fdbf032457bcca49a0c222bde92" => :el_capitan
    sha256 "2950e2e4a2f492e76cc42a097b537336bd92c07c3057cc35057cbb01af445a1e" => :yosemite
    sha256 "2386d1592d78c701e237ce1fa74478d762551e415320d8664270865b566502e7" => :mavericks
  end

  head do
    url "https://github.com/nzjrs/osm-gps-map.git"
    depends_on "gnome-common" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gtk-doc" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "gdk-pixbuf"
  depends_on "gobject-introspection"
  depends_on "libsoup"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <osm-gps-map.h>

      int main(int argc, char *argv[]) {
        OsmGpsMap *map;
        gtk_init (&argc, &argv);
        map = g_object_new (OSM_TYPE_GPS_MAP, NULL);
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    glib = Formula["glib"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gtkx3 = Formula["gtk+3"]
    pango = Formula["pango"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{pango.opt_include}/pango-1.0
      -I#{include}/osmgpsmap-1.0
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lglib-2.0
      -lgtk-3
      -lgobject-2.0
      -lpango-1.0
      -losmgpsmap-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
