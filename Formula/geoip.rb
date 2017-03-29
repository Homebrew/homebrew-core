class Geoip < Formula
  desc "This library is for the GeoIP Legacy format (dat)"
  homepage "https://github.com/maxmind/geoip-api-c"
  url "https://github.com/maxmind/geoip-api-c/releases/download/v1.6.10/GeoIP-1.6.10.tar.gz"
  sha256 "cb44e0d0dbc45efe2e399e695864e58237ce00026fba8a74b31d85888c89c67a"

  head "https://github.com/maxmind/geoip-api-c.git"

  bottle do
    cellar :any
    sha256 "96fde02debe1a354a547110dd5ee6803ea4178de4aef37337ebb48c69f279c8e" => :sierra
    sha256 "dc7c79eef8500456198b3ba981c13498c049b2f8c4398fe885534c386dfbf283" => :el_capitan
    sha256 "0525ae799027334cafb551a349c7837c8b17853660797dff430b035ca0eedc65" => :yosemite
    sha256 "5ee66187d1b4510fd463ebb8bf360c2d78a4252467a0e10e905a2a3502f9bcaa" => :mavericks
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
