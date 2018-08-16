class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v3.1.0/geoipupdate-3.1.0.tar.gz"
  sha256 "70da23bc1e33007b20e4d68ace037c51ba6ff9af766ac4fdb38b9a42b872c774"

  bottle do
    sha256 "21e6eb895c21437b2e4e47f353fc6974dea63e2494e1daedc89f8a86dfca344f" => :high_sierra
    sha256 "7c4bb242c2967ebb8aae34180fffef614bb24827a08a4bc4911fe0d848281698" => :sierra
    sha256 "e9e1a7d8ac8129b9ef393f140599b325028ea945d5b3775b9908357892903018" => :el_capitan
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
