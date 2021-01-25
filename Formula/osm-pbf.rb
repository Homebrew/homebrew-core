class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/scrosby/OSM-binary/archive/v1.5.0.tar.gz"
  sha256 "2abf3126729793732c3380763999cc365e51bffda369a008213879a3cd90476c"
  license "LGPL-3.0"

  bottle do
    cellar :any
    sha256 "cde905f5e30549acb2e9d002b95e8ebbf581aa078108abddc2e8a645329ffa71" => :big_sur
    sha256 "5cfaf02637be652c5d7913288a576961c1d6bd9bf67c7818196c18aff0bda149" => :arm64_big_sur
    sha256 "a61abe978818b7abd27cf0716204b24cc0135f2589298b63d7cad95577d2550f" => :catalina
    sha256 "16ba12db1cc49ec09169e8463cdac17edeefb91ef7a32ff0eaa62556bfc409a0" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "protobuf"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "resources/sample.pbf"
  end

  test do
    assert_match "OSMHeader", shell_output("#{bin}/osmpbf-outline #{pkgshare}/sample.pbf")
  end
end
