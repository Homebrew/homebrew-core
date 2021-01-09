class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/scrosby/OSM-binary/archive/v1.5.0.tar.gz"
  sha256 "2abf3126729793732c3380763999cc365e51bffda369a008213879a3cd90476c"
  license "LGPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb6525bab64e792c04a42dc14f4c282357a1ca810528291c708ad4bb675850ef" => :big_sur
    sha256 "d69b8678764efa4aa16a5eebd85610bdd3ec411655946447d56ca7571f8057db" => :arm64_big_sur
    sha256 "848d0ffd20470d7988d5bb9f4a93e5b58f799646a4c551732c271d4d57b5a1f8" => :catalina
    sha256 "324c716503518b77533db927144643db877d3cf3297234333c056ae45f85d911" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "protobuf"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "resources/sample.pbf"
  end

  test do
    assert_match "OSMHeader", shell_output("#{bin}/osmpbf-outline #{pkgshare}/sample.pbf")
  end
end
