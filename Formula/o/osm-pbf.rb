class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fea28450b4e589a230b2ad3bc9c09ebf82e00fbb42009eff7bd2e9107f406e28"
    sha256 cellar: :any,                 arm64_ventura:  "5b7eb454f12ec4ca03e72a30df8c8a7c3bc97a3fc29dd0fe68a698483f1860d3"
    sha256 cellar: :any,                 arm64_monterey: "ea59fb9471428385f823d3846680d4771575af781ecca0dca6f1be67df432367"
    sha256 cellar: :any,                 sonoma:         "170d31effbbbcf7a8f1523d2279ab2315516e77b370d2cedceeb6b93e4f50f17"
    sha256 cellar: :any,                 ventura:        "3291a80e6ae49dddb36c226d3bf480b6043f758e6f9eb20171c9010d9608eb7b"
    sha256 cellar: :any,                 monterey:       "e339d429555f1df0bd8cf24caea2e42d850e91ec5f8df965e2462de3c35c173d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19883fe86c5fe064f3c70c8b18acd20d356465fe95548e8446664644eba9ed59"
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
