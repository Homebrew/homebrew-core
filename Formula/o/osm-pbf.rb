class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "2abf3126729793732c3380763999cc365e51bffda369a008213879a3cd90476c"
  license "LGPL-3.0-or-later"
  revision 5

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "69f34c69bcd270ae89cfa9a37e3dc63cc576f25832de71f1d85e09a91c47b74b"
    sha256 cellar: :any,                 arm64_ventura:  "99b03549fff7d28e0a35a1151dc96eebd60860a510fff1cb5a9c2c9889b633f2"
    sha256 cellar: :any,                 arm64_monterey: "f5926acb0bcc766a4429b2025fa9b06e9f733c4692b4c1156cfaab0216daf0a0"
    sha256 cellar: :any,                 sonoma:         "d6b873eb49d8b84c702ebf0df89799d7e6d245bc94ac31fd3f5921fcfdb325a7"
    sha256 cellar: :any,                 ventura:        "0289b857240b19a3830b43cd21f32b8cd884d79cd9ea29f7e53ec11a638e0b8a"
    sha256 cellar: :any,                 monterey:       "34e920db76c1400c893e3ff63e045e42d60165be93fd936a5b031ca4e62d31c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5641ca48a5aab011da6a3a676c5137cc3471e33fa1aabb5ef27b569f8701e5b2"
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
