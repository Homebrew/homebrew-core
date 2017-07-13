class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v2.4.0/geoipupdate-2.4.0.tar.gz"
  sha256 "8b4e88ce8d84e9c75bc681704d19ec5c63c54f01e945f7669f97fb0df7e13952"
  revision 1

  bottle do
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
    # Configure for free GeoLite2 and GeoLite Legacy Databases
    # See https://dev.maxmind.com/geoip/geoipupdate/
    inreplace "conf/GeoIP.conf.default" do |s|
      s.gsub! /^UserId 0$/, "UserId 999999"
      s.gsub! /^# (ProductIds 506 517 533 GeoLite.*$)/, "\\1"
    end

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
