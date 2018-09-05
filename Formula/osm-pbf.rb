class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/scrosby/OSM-binary/archive/v1.3.3.tar.gz"
  sha256 "a109f338ce6a8438a8faae4627cd08599d0403b8977c185499de5c17b92d0798"
  revision 5

  bottle do
    cellar :any_skip_relocation
    sha256 "3199cc807995df84916d63c216d0a2793ed8af5513bed9488d397e4efcf745c2" => :mojave
    sha256 "68e5bf0c9924719525b0522da2656ae43a7cdb11bcdf3a6c05e481c3f5b242ec" => :high_sierra
    sha256 "c4f104fa72861e982b9071e656675a3ed3c4bf2d37fddeab3c5eb952d7864d9b" => :sierra
    sha256 "6e6902ebcdb50d95ab0aeeb9fcc086956eb768110f1646839dba876b1f31c643" => :el_capitan
  end

  depends_on "protobuf"

  needs :cxx11

  def install
    ENV.cxx11

    cd "src" do
      system "make"
      lib.install "libosmpbf.a"
    end
    include.install Dir["include/*"]
  end
end
