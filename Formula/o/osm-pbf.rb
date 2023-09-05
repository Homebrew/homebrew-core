class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/openstreetmap/OSM-binary/archive/v1.5.0.tar.gz"
  sha256 "2abf3126729793732c3380763999cc365e51bffda369a008213879a3cd90476c"
  license "LGPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "76cb439da420f4f46f3c05790353b1bd5c6fb41f1660be72c20debaefb8f21c4"
    sha256 cellar: :any,                 arm64_monterey: "2686e5c465cae1bf9dcfe5b566300ce59333a308a2001f46081d216304f8d30b"
    sha256 cellar: :any,                 arm64_big_sur:  "c1a4fd86fc7b23fe2534bd50d1c17d8c929081f4861970bef9c91771a1fd85fe"
    sha256 cellar: :any,                 ventura:        "6999adc180bc02399df196b0d130f9e084d3ef8a8f604210e71157eef0cce1f1"
    sha256 cellar: :any,                 monterey:       "e838c398a9a89da23a363c48432999a1a7e9a696af1cae28f43df55eeb92eeb7"
    sha256 cellar: :any,                 big_sur:        "be7f0cf8535457feecb3dec2cfc76bf74f88de4efa73a77c1c5114c25ac4309b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "167796ef8b8d49e257eb7909e314b4156b2b9865f44a2b23bd1c7b0cbea5fc3f"
  end

  depends_on "cmake" => :build
  depends_on "protobuf@21"

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
