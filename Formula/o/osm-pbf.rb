class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "2abf3126729793732c3380763999cc365e51bffda369a008213879a3cd90476c"
  license "LGPL-3.0-or-later"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "905333fabb9981bb5938d258297bb99f7945b1b822fe2e7c12f0ca53f4d12654"
    sha256 cellar: :any,                 arm64_ventura:  "79c93d64f5e7e9dace5a03d9d6c3c5333af90fdeb47d401da6d0c48ecbdeb174"
    sha256 cellar: :any,                 arm64_monterey: "18413b4d85ce3d615ae1dfae2dbf8016048c0211d1d79e039cc7b19e04f2c2e9"
    sha256 cellar: :any,                 sonoma:         "a8ebdf0b3cace79553773cb5674abd91acda13fcb86e237f96cf6c97dfbde450"
    sha256 cellar: :any,                 ventura:        "9d5d04b13a47cc721dd37312da69daab6bf0ed1556484b86e70abb3e39c5c012"
    sha256 cellar: :any,                 monterey:       "0bd3eba8a302f8dd16ce9271c0192656a579cc9eba19a06f9039e194db14f9e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23d16b76786eb8e65266a74e8a1eb222af262322a8fe8699e36635212e50d5f9"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"

  uses_from_macos "zlib"

  def install
    # Work around build failure with Protobuf 22+ which needs C++14/C++17
    # Issue ref: https://github.com/openstreetmap/OSM-binary/issues/76
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_STANDARD 11)", "set(CMAKE_CXX_STANDARD 17)"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "resources/sample.pbf"
  end

  test do
    assert_match "OSMHeader", shell_output("#{bin}/osmpbf-outline #{pkgshare}/sample.pbf")
  end
end
