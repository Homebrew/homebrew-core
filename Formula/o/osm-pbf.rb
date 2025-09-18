class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 18

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "201123b2e5bcf726eddefb04e9d5a81ca6b1a59f63c551c903a313fbc4b7594a"
    sha256 cellar: :any, arm64_sequoia: "8f8b9c69ae38b0714d496bfe782c50ca6efb8dfad356e83d9464ac972b547135"
    sha256 cellar: :any, arm64_sonoma:  "9e31dd2a842050ec2c8ba0350390fa31a5672528b177ff905d4b9d26a95d0434"
    sha256 cellar: :any, sonoma:        "fffc805fc607deed663522bf00c2c1125481ebf50ecc8c9a2ca0ab2f4ee869b1"
    sha256               arm64_linux:   "1859c124d852c0475773ef00bb567a912ff6b232e069199ad90b0fd99ea6e6f5"
    sha256               x86_64_linux:  "8badf1715e945869dd9ab869bceb990921516eb36d7ee7db23b80757edd0f1ac"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "resources/sample.pbf"
  end

  test do
    assert_match "OSMHeader", shell_output("#{bin}/osmpbf-outline #{pkgshare}/sample.pbf")
  end
end
