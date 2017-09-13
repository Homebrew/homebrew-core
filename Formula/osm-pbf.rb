class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/scrosby/OSM-binary/archive/v1.3.3.tar.gz"
  sha256 "a109f338ce6a8438a8faae4627cd08599d0403b8977c185499de5c17b92d0798"
  revision 4

  bottle do
    cellar :any_skip_relocation
    sha256 "5a8c5f67cbaf2fca7171faeeeafd535fe16f5f1cb3399bed97e67c371b2cdf7b" => :sierra
    sha256 "c38b6254cdbb12ab370e807d8c6dcd756e081ab95b684ea5efad449238e52f00" => :el_capitan
    sha256 "2aa7a626188511fe06efa26f99b6d438391c7299ce7026ca08fa4c4069d6cc03" => :yosemite
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
