class OsmGpsMap < Formula
  desc "GTK+ library to embed OpenStreetMap maps"
  homepage "https://github.com/nzjrs/osm-gps-map"
  license "GPL-2.0-or-later"
  revision 2

  stable do
    url "https://github.com/nzjrs/osm-gps-map/releases/download/1.2.0/osm-gps-map-1.2.0.tar.gz"
    sha256 "ddec11449f37b5dffb4bca134d024623897c6140af1f9981a8acc512dbf6a7a5"

    depends_on "libsoup@2"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256                               arm64_sequoia:  "86a72e93e60138253d415f0f8350e2a08f01cf670631f159cbcb9aef453991f0"
    sha256                               arm64_sonoma:   "4e99312645cad4b62bce40d08360aaf0071a7a5fce6e8331c3940fc9956d6a30"
    sha256                               arm64_ventura:  "2bc5f12b6808b31bbc6fb791a90a8561c33eb88ac4d937d9d48df795570fe2fb"
    sha256                               arm64_monterey: "8dddb7d2eee3341e52742fb0d9d2503a081dcf53777048e614ee0d873314af3a"
    sha256                               sonoma:         "14f294ea2b9e3031d6e7f53b06f926846e3a2de6e7ff7c61a1ab68ed5f651d58"
    sha256                               ventura:        "6cda5bd18d03de3bb11ddff9bf3b4451257f612ae26a03cf3d2f2cf09bdea496"
    sha256                               monterey:       "23bdada15af6c8a29c89925199ebf59225d69edc709531a33f82f8e9be659085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9267eb6c95ec708b3d3d1df50e7201f58ae05fb05816cf17656c5a4c71875ab2"
  end

  head do
    url "https://github.com/nzjrs/osm-gps-map.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    depends_on "libsoup"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", "--enable-introspection", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    harfbuzz = Formula["harfbuzz"]
    pango = Formula["pango"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
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

    # (test:40601): Gtk-WARNING **: 23:06:24.466: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
