class Geoip < Formula
  desc "This library is for the GeoIP Legacy format (dat)"
  homepage "https://github.com/maxmind/geoip-api-c"
  url "https://github.com/maxmind/geoip-api-c/releases/download/v1.6.10/GeoIP-1.6.10.tar.gz"
  sha256 "cb44e0d0dbc45efe2e399e695864e58237ce00026fba8a74b31d85888c89c67a"

  head "https://github.com/maxmind/geoip-api-c.git"

  bottle do
    sha256 "3ec062926f17a28236d503ba62115a2c6abdd9cfb8d4c42581a24a5849c98f56" => :sierra
    sha256 "d60281103536558032346574dbf2b9f37f4230ac2331e19b78f2bcf4b2fa6b83" => :el_capitan
    sha256 "50c7c2efc87e07d8001312a970494900679e87ca84c53ca070c0e734506313e4" => :yosemite
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
