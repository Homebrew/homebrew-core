class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.6.0.tar.gz"
  sha256 "e64c3cb6f2c999e11e8401814305cbd7676c9d78a0131e06ed9dd950606dffcd"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 "77ebb07ee45200545ffad44cbc1993195dab983bbdf2fa79b1faeea629e5bab3" => :big_sur
    sha256 "97e31b482981f2027c4223e8392b6e4d1bb6f5845abc4a92fd2f31fe60092bad" => :catalina
    sha256 "94cf0c34c2e48c8976efd32281b8b899ffb984f9828ab7e5fdfd92dcd8122d1b" => :mojave
    sha256 "371eed40eee1c2e15a20c9b9c942cd55f5a67b9875bfb57fc6ff905af8e19300" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "make", "CONFFILE=#{etc}/GeoIP.conf", "DATADIR=#{var}/GeoIP", "VERSION=#{version} (homebrew)"

    bin.install  "build/geoipupdate"
    etc.install  "build/GeoIP.conf"
    man1.install "build/geoipupdate.1"
    man5.install "build/GeoIP.conf.5"
  end

  def post_install
    (var/"GeoIP").mkpath
  end

  test do
    system "#{bin}/geoipupdate", "-V"
  end
end
