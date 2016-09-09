class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/scrosby/OSM-binary/archive/v1.3.3.tar.gz"
  sha256 "a109f338ce6a8438a8faae4627cd08599d0403b8977c185499de5c17b92d0798"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1bd80de2eccb7b01f0b2c73e735e02a14d1cc0168a2615bd2825a5413aeeba3" => :el_capitan
    sha256 "c102e66477bbbb75dfd91e0349659f59781002246a57775f2d7cab5fbf7cae27" => :yosemite
    sha256 "6a9a5fb19889732dbe9d9837e38d417be53277a44df6b8fb2191c8f9f4872b70" => :mavericks
  end
  revision 1

  depends_on "protobuf"

  def install
    cd "src" do
      system "make"
      lib.install "libosmpbf.a"
    end
    include.install Dir["include/*"]
  end
end
