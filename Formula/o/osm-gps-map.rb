class OsmGpsMap < Formula
  desc "GTK+ library to embed OpenStreetMap maps"
  homepage "https://github.com/nzjrs/osm-gps-map"
  url "https://github.com/nzjrs/osm-gps-map/releases/download/1.2.2/osm-gps-map-1.2.2.tar.gz"
  sha256 "051383588f0fdb60f59047c6559110c35025ea72b6eca700af532c020a6b55ec"
  license "GPL-2.0-or-later"

  bottle do
    sha256               arm64_golden_gate: "9a229e9b70d62a524600d7f89ebda612f222bffabd2340109bd9ba1ed96d4247"
    sha256               arm64_tahoe:       "175de31db5ba8bd2636c7fa860f6a13050ea71363f9312c339cde398493c5167"
    sha256               arm64_sequoia:     "a8e0f7a4b7046c6c30afbd7a1931b617be827530341d606ef316309db1ad8181"
    sha256 cellar: :any, arm64_linux:       "9e3dd4c5d6fb320fa3cd3cac822da56a6e3da0597f939b39e8e43f0fe86de760"
    sha256 cellar: :any, x86_64_linux:      "04cf9db2cbcd94d6be58587b2fa5b247c3bdedf930f1889fdce6d203454cef0c"
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
      system formula_opt_bin("xorg-server")/"xvfb-run", "./test"
    else
      system "./test"
    end
  end
end
