class OsmGpsMap < Formula
  desc "GTK+ library to embed OpenStreetMap maps"
  homepage "https://github.com/nzjrs/osm-gps-map"
  url "https://github.com/nzjrs/osm-gps-map/releases/download/1.2.1/osm-gps-map-1.2.1.tar.gz"
  sha256 "277d6835220a6a2954e09eb304a8cd6ff49b72542c97c4fc36e53e905f2a747c"
  license "GPL-2.0-or-later"

  bottle do
    sha256               arm64_tahoe:   "bdd8de2894986d597f3bd66c3a51c2cab55256b6e5cf16871e3bb1a60ef69428"
    sha256               arm64_sequoia: "fd1c1933d296a9cc05ed9bb2a3e3349f0bcb90d493ce35849b3f86bb0051ac46"
    sha256               arm64_sonoma:  "b4f804b3ecc408958cbd01df994c4c4af8a97e6f5337d7d8f66a23090943256e"
    sha256               sonoma:        "e5c7bc673363392b5e3f76e4f5ab27711f1d9cd37397e6bd279b95f5176774af"
    sha256 cellar: :any, arm64_linux:   "7bee7a5fd377ceff39f2f406ca5331d80cc389ced2febea2914b89d813b5b019"
    sha256 cellar: :any, x86_64_linux:  "a0b65784639acb4e288c00fe6fd6422fb239a42e601f549dfd27d04302fb83dd"
  end

  head do
    url "https://github.com/nzjrs/osm-gps-map.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libsoup"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  on_linux do
    depends_on "xorg-server" => :test
  end

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", "--enable-introspection", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <osm-gps-map.h>

      int main(int argc, char *argv[]) {
        OsmGpsMap *map;
        gtk_init (&argc, &argv);
        map = g_object_new (OSM_TYPE_GPS_MAP, NULL);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs osmgpsmap-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    if OS.linux? && ENV.exclude?("DISPLAY")
      system Formula["xorg-server"].bin/"xvfb-run", "./test"
    else
      system "./test"
    end
  end
end
