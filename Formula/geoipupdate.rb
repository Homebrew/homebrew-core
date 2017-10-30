class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v2.5.0/geoipupdate-2.5.0.tar.gz"
  sha256 "5119fd0e338cd083e886228b26679c64bcbaade8a815be092aecf865a610ab26"

  bottle do
    sha256 "323ae245cabc43f6dfc5dd95625eb4aa8fd87cf33dfc3c0ad75f043f48ffff88" => :high_sierra
    sha256 "ecc561b023e6ae9c57c4dcbe248407bfbf8b6f73e28da9e9a0395759b1fdb931" => :sierra
    sha256 "5a56005484abf3771b79707fc79a669803e683f1573c12a854c23f4b92d78ee0" => :el_capitan
    sha256 "e984990bc05d7f13585e6b19f309dbd56c181f15f09faa08333ba8020fb1876a" => :yosemite
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
