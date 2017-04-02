class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/scrosby/OSM-binary/archive/v1.3.3.tar.gz"
  sha256 "a109f338ce6a8438a8faae4627cd08599d0403b8977c185499de5c17b92d0798"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "5e4763d81ff7e2f84aa8746f58131da90dd30f12809b110d426981756f6a20b9" => :sierra
    sha256 "18f7f43241bbbd1a5845a2b45aa9af3780aa01fd5eb45b6d02914b1f44808892" => :el_capitan
    sha256 "a7aebea3e0e484c77ff435579c4dc4c7e5456546e54d61daeaa020149e8873a3" => :yosemite
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
