class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.7.1.tar.gz"
  sha256 "e3176325f916571244562a2fec58e0c9ce624f84dbf946616921be8521cbfd94"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 big_sur:  "5fe5376c5e4690b2614bb6de8e9f6849603e5e62cde300dd6744cc52394e7887"
    sha256 catalina: "8e6aa341eebc779514e9db7aabfc862d9c56513d26f9058631906654ed1d430a"
    sha256 mojave:   "548134f2f54d67e3ff04d86c0dcc7b937b06fd05c25e173a1ac11b2826db0b69"
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
