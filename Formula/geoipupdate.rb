class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v3.0.1/geoipupdate-3.0.1.tar.gz"
  sha256 "5701b9bd9028fc10194069d996823c9c94d52a8fdf4c578519684586f76fb602"

  bottle do
    sha256 "075dda0c40a4c5bbc192f39652a39feef3863f3b21733d5a9b84cd88479d6375" => :high_sierra
    sha256 "d8cca68df8899518f902db9e705c190a4c78ac281bb7a9d16ee7d02d24207df5" => :sierra
    sha256 "c795bce24c8eac0230cecf3dc42f94a9bf850a73d2b2e57ab030a7f9acb170e5" => :el_capitan
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
