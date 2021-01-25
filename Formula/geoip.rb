class Geoip < Formula
  desc "This library is for the GeoIP Legacy format (dat)"
  homepage "https://github.com/maxmind/geoip-api-c"
  url "https://github.com/maxmind/geoip-api-c/releases/download/v1.6.12/GeoIP-1.6.12.tar.gz"
  sha256 "1dfb748003c5e4b7fd56ba8c4cd786633d5d6f409547584f6910398389636f80"
  license "LGPL-2.1"
  head "https://github.com/maxmind/geoip-api-c.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "a3bcb8d9c69277cb943fa30f00715325ee1c4f0c3e9aeb58e0c4a288f6705313" => :big_sur
    sha256 "fd8787e3b88f91d97504992874d3fd358c6865e03fc19c5123b8e7f1a691f0dd" => :arm64_big_sur
    sha256 "140477567aa37b0418e1976bdc5f75bc0f933405c157e7170ae3441ee3fc74aa" => :catalina
    sha256 "e10d69d8595116bdb562b0ede63d7bd04f606c66becd3c03fb1e6d06ba99a964" => :mojave
  end

  resource "database" do
    url "https://src.fedoraproject.org/lookaside/pkgs/GeoIP/GeoIP.dat.gz/4bc1e8280fe2db0adc3fe48663b8926e/GeoIP.dat.gz"
    sha256 "7fd7e4829aaaae2677a7975eeecd170134195e5b7e6fc7d30bf3caf34db41bcd"
  end

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
    ln_s "GeoLiteCountry.dat", full if !full.exist? && !full.symlink?
    full = Pathname.new "#{geoip_data}/GeoIPCity.dat"
    ln_s "GeoLiteCity.dat", full if !full.exist? && !full.symlink?
  end

  test do
    resource("database").stage do
      output = shell_output("#{bin}/geoiplookup -f GeoIP.dat 8.8.8.8")
      assert_match "GeoIP Country Edition: US, United States", output
    end
  end
end
