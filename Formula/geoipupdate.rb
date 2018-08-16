class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v3.1.0/geoipupdate-3.1.0.tar.gz"
  sha256 "70da23bc1e33007b20e4d68ace037c51ba6ff9af766ac4fdb38b9a42b872c774"

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
