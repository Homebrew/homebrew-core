class Geoip < Formula
  desc "This library is for the GeoIP Legacy format (dat)"
  homepage "https://github.com/maxmind/geoip-api-c"
  url "https://github.com/maxmind/geoip-api-c/releases/download/v1.6.12/GeoIP-1.6.12.tar.gz"
  sha256 "1dfb748003c5e4b7fd56ba8c4cd786633d5d6f409547584f6910398389636f80"
  license "LGPL-2.1-or-later"
  head "https://github.com/maxmind/geoip-api-c.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "5ecf048e55f55fd13e12a4a818f5ecb4147f1cce670463b933983972dd9399f6"
    sha256 cellar: :any,                 arm64_sonoma:   "8654c865535c713142b5c4ac3dffc246a0651c06b60111983c043fcad880da3e"
    sha256 cellar: :any,                 arm64_ventura:  "40ef31c663a905f3786b8e410f651ee97cc0ae805d7c22d52c20b9c518ba12ba"
    sha256 cellar: :any,                 arm64_monterey: "c2ae63b815cc930a90d57c78a1d7a51a57085d67aa20431db716982353a950b2"
    sha256 cellar: :any,                 arm64_big_sur:  "fd8787e3b88f91d97504992874d3fd358c6865e03fc19c5123b8e7f1a691f0dd"
    sha256 cellar: :any,                 sonoma:         "882a5b16b7c412deb991c2719b2c0b046b37afe618ea575f821baffb56667b9c"
    sha256 cellar: :any,                 ventura:        "8fea8cddc3695facc75949f58d6c6b71763cc85be37cfe812f58591234e6f0e6"
    sha256 cellar: :any,                 monterey:       "f441710caf103a53272a50e4720f1885f858986c6306fcc4a078ef8d193cca59"
    sha256 cellar: :any,                 big_sur:        "a3bcb8d9c69277cb943fa30f00715325ee1c4f0c3e9aeb58e0c4a288f6705313"
    sha256 cellar: :any,                 catalina:       "140477567aa37b0418e1976bdc5f75bc0f933405c157e7170ae3441ee3fc74aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb045793a66f36a2737a3bdc3c8513c5822702778c223123dceceff61e847080"
  end

  # EOL and repo archived on 2022-05-31. Superseded by `libmaxminddb`.
  disable! date: "2024-12-12", because: :repo_archived

  resource "database" do
    url "https://src.fedoraproject.org/lookaside/pkgs/GeoIP/GeoIP.dat.gz/4bc1e8280fe2db0adc3fe48663b8926e/GeoIP.dat.gz"
    sha256 "7fd7e4829aaaae2677a7975eeecd170134195e5b7e6fc7d30bf3caf34db41bcd"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--datadir=#{var}",
                          "--prefix=#{prefix}"
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
