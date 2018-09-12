class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v3.1.1/geoipupdate-3.1.1.tar.gz"
  sha256 "3de22e3fe3282024288a00807bbea9a1ffa2d1e8fe9c611f4b14a5b4d8ebe08a"

  bottle do
    sha256 "9cf68c91a00193bed2bd55b3c2d8add1fa937433a429af7c01829b14a58eb7fa" => :mojave
    sha256 "1e45c489ab5d3022b71e00adca105287de4175ae999552a1f0f62981a16cbf4c" => :high_sierra
    sha256 "d13fd47dd374265af81e2824335b714bd647359671f82ed6643ae988722647fc" => :sierra
    sha256 "a8fdd107eca63868f7ae9e216f3ecab4bb1c0ce635d9bda0fdb03d35f37d1380" => :el_capitan
  end

  head do
    url "https://github.com/maxmind/geoipupdate.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--datadir=#{var}",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  def post_install
    (var/"GeoIP").mkpath
    system bin/"geoipupdate", "-v"
  end

  test do
    system "#{bin}/geoipupdate", "-V"
  end
end
