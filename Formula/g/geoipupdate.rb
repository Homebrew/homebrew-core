class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/refs/tags/v7.1.0.tar.gz"
  sha256 "8b4c1c0032793513d86e4f1a68f771212f8ac54c8a1fe97a6132eb8f2bd45c53"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "879138f872eb4fbb96895268287121d7c27966d259b40d890ec1218e918399f2"
    sha256 arm64_sonoma:  "fcb0c24006056d5dc86f6b65236c54d03f9439b2d51f4a8fa65e728a3d4f1654"
    sha256 arm64_ventura: "5be3417165d85f2df25aba622f6fd5f8807c4f57784bdda24553de2c0580e26d"
    sha256 sonoma:        "fe83e7f30b79b4408a11e5afa9334e4840431ee6baea5327f52ead9750023338"
    sha256 ventura:       "aa0968b8b867dc8897d0bebb1f3d1e5718df65afcab1f717d334fc9bff570d1c"
    sha256 x86_64_linux:  "af703e88801ea8b831adee390b374262313aef27cdafd2ad3488fb8b60ac360c"
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
    system bin/"geoipupdate", "-V"
  end
end
