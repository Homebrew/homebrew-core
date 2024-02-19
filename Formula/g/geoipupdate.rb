class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "71a5b3125bb7d5f1b78382ec37a0d3e966caea3215689531a32cddc7e4437ca6"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "d1dac2a8404082a26e6308a176fc63a5e99d4f41b7fdbab2921027105adbbf22"
    sha256 arm64_ventura:  "02633e5f62313de4268a292b75ac46231bb401471acdeec4475e0d62d3e9c669"
    sha256 arm64_monterey: "0c8eb1feaa332db207e789bdbbd8e6f430f314bcd6b7a8c908e4dbf986e97fc4"
    sha256 sonoma:         "bd972662b519e037ac80f692490a481357a1ff126d7b92929da36bb68e57ae58"
    sha256 ventura:        "4d44e8a2620f9c9cc1c63da3946ded217957dbaae38daff14c130e6962312cf9"
    sha256 monterey:       "93e14ba810188833b0696ab3addb347b9813702842ba6570d1b353f4824e8725"
    sha256 x86_64_linux:   "5f95d716dda0e8e6a5ecd867ee122325270024db97af9dd5163f7560a551940f"
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
