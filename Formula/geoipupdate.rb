class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v2.4.0/geoipupdate-2.4.0.tar.gz"
  sha256 "8b4e88ce8d84e9c75bc681704d19ec5c63c54f01e945f7669f97fb0df7e13952"
  revision 1

  bottle do
    sha256 "c73d5d3d4ca5fd9247781271a804d92ea56069fa762ecb65378220e6c2e8bf26" => :sierra
    sha256 "d37e9d640cb63cd56947a9e5cc0d1cafa3200daae9af2c3eccbd63fa0901d0a7" => :el_capitan
    sha256 "b8ea3881d098a236eae73e69ad59d4a0b8da4ae6b07985a4bc5ce9e3c27f7187" => :yosemite
  end

  head do
    url "https://github.com/maxmind/geoipupdate.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # Configure for free GeoLite2 and GeoLite Legacy Databases
    # See http://dev.maxmind.com/geoip/geoipupdate/
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
