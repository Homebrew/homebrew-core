class OsmGpsMap < Formula
  desc "GTK+ library to embed OpenStreetMap maps"
  homepage "https://nzjrs.github.com/osm-gps-map/"
  url "https://github.com/nzjrs/osm-gps-map/releases/download/1.1.0/osm-gps-map-1.1.0.tar.gz"
  sha256 "8f2ff865ed9ed9786cc5373c37b341b876958416139d0065ebb785cf88d33586"

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
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end
