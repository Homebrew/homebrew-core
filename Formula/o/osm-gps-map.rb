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
    sha256 cellar: :any_skip_relocation, arm64_linux:    "796fe43d3fd75d366860ad62c3f15e98a00183616f71ceea03e6256975152406"
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
  depends_on "pkgconf" => [:build, :test]

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
    (testpath/"test.c").write <<~C
      #include <osm-gps-map.h>

      int main(int argc, char *argv[]) {
        OsmGpsMap *map;
        gtk_init (&argc, &argv);
        map = g_object_new (OSM_TYPE_GPS_MAP, NULL);
        return 0;
      }
    C

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libsoup@2"].opt_lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs osmgpsmap-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags

    # (test:40601): Gtk-WARNING **: 23:06:24.466: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
