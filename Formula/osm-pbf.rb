class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/scrosby/OSM-binary/archive/v1.3.3.tar.gz"
  sha256 "a109f338ce6a8438a8faae4627cd08599d0403b8977c185499de5c17b92d0798"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "ee2d7681e16f0931db87dd6b02b6c9f100ca2f30c7ae241f8f59cd60f1f4ca62" => :sierra
    sha256 "adc37e7c306023ed08d729760b2296c205feb4de9c2aaa17ece81d3067da2b7c" => :el_capitan
    sha256 "0b8aeff1975a0cdd51b835a378ae1f93487ad4e12fbc9f73ccb27e0413b4d768" => :yosemite
  end

  depends_on "protobuf"

  def install
    cd "src" do
      system "make"
      lib.install "libosmpbf.a"
    end
    include.install Dir["include/*"]
  end
end
