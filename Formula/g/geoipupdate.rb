class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "5c08b39d2ac49ad492138b3d618dddac130065852b6237ec450bac856ace7e0a"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "53761d79291dc1203d796c4925cb052ef269053a56b9797ca4d1d0e6546226b2"
    sha256                               arm64_sequoia: "7af9a34dbbde40e9fe6d2090dcce008f1dbb41384fab7c98faae51d752496d2f"
    sha256                               arm64_sonoma:  "238536387d47281a17c77d96c90908955a605d5ed84f9c477472425e41780cc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "04af5528d8b08aee621646895a7c6fc814ccb21af176401bdaa354c43e81a55a"
    sha256                               arm64_linux:   "db7cb6597e6a838f977105f425129bfe94a898f5b4315cde46e379a34e699834"
    sha256                               x86_64_linux:  "68fcf40ea953d7e52b213984cd3235c50f226395dc352563c48528446358b9be"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "CONFFILE=#{etc}/GeoIP.conf", "DATADIR=#{var}/GeoIP", "VERSION=#{version} (homebrew)"

    bin.install  "build/geoipupdate"
    etc.install  "build/GeoIP.conf"
    man1.install "build/geoipupdate.1"
    man5.install "build/GeoIP.conf.5"
    (var/"GeoIP").mkpath
  end

  test do
    system bin/"geoipupdate", "-V"
  end
end
