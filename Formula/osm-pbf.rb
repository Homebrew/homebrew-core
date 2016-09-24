class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/scrosby/OSM-binary/archive/v1.3.3.tar.gz"
  sha256 "a109f338ce6a8438a8faae4627cd08599d0403b8977c185499de5c17b92d0798"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "23a03eeded0fc71a344fc9503b2bd555c0b0d9642a2057381d7d8e58d55a08cf" => :el_capitan
    sha256 "a43e77aec14db2368d6bf3d20907e385ce873ba9e752727f91b457b5b89ad6e2" => :yosemite
    sha256 "ac087d56376dbff9345ddab92b8c17aa3e9318dbd109d7b243e0ec19efeaa4bd" => :mavericks
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
