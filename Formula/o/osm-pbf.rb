class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c5f1286d4134408ad4b995c5a06047ca1420c3076a0daf09f7349cef9bfa9e99"
    sha256 cellar: :any,                 arm64_ventura:  "5caae35729676e53a51b4aacacee98e68d3738d2fd6a8f8a5904c35b9e1d4ffa"
    sha256 cellar: :any,                 arm64_monterey: "4485b816a05eece6e66e670eb8c48a647e4302f242d35cffda0e970739dbbba2"
    sha256 cellar: :any,                 sonoma:         "e394525dd0e20a3e8545f8cc08a4b116bb80226a6563055268bd17bc8e11ec01"
    sha256 cellar: :any,                 ventura:        "9d0906ccc3dd08a1837ef1b9f0b6166745774cf0e55773869d8770445d8685d0"
    sha256 cellar: :any,                 monterey:       "5413f0af75ee23d40dee7da4bc2f874a750b90cb68276eac21dd511b9470bee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a052a7024ae0ea8710387dc3b85a257938a45ab54e024b5b51a2a5f8e84a0ff"
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
