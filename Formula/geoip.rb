class Geoip < Formula
  desc "This library is for the GeoIP Legacy format (dat)"
  homepage "https://github.com/maxmind/geoip-api-c"
  url "https://github.com/maxmind/geoip-api-c/releases/download/v1.6.11/GeoIP-1.6.11.tar.gz"
  sha256 "b0e5a92200b5ab540d118983f7b7191caf4faf1ae879c44afa3ff2a2abcdb0f5"

  head "https://github.com/maxmind/geoip-api-c.git"

  bottle do
    sha256 "e1280ddceb39252c62e8e78a25f8abada91411b165fc521259d0d3105eb2763a" => :sierra
    sha256 "01fedcc459368426a4dd58437d75685128fc07911271ce69f49cb9ebd1eddf16" => :el_capitan
    sha256 "698e05101fa1a4c93a1a3bc96b95b193d000010e77c51ae9965af7ac4828983f" => :yosemite
  end

  depends_on "geoipupdate" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--datadir=#{var}",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  def post_install
    geoip_data = Pathname.new "#{var}/GeoIP"
    geoip_data.mkpath

    # Since default data directory moved, copy existing DBs
    legacy_data = Pathname.new "#{HOMEBREW_PREFIX}/share/GeoIP"
    cp Dir["#{legacy_data}/*"], geoip_data if legacy_data.exist?

    full = Pathname.new "#{geoip_data}/GeoIP.dat"
    ln_s "GeoLiteCountry.dat", full unless full.exist? || full.symlink?
    full = Pathname.new "#{geoip_data}/GeoIPCity.dat"
    ln_s "GeoLiteCity.dat", full unless full.exist? || full.symlink?
  end

  test do
    system "curl", "-O", "https://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz"
    system "gunzip", "GeoIP.dat.gz"
    system "#{bin}/geoiplookup", "-f", "GeoIP.dat", "8.8.8.8"
  end
end
