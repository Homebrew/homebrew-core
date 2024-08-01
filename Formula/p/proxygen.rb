class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.07.15.00/proxygen-v2024.07.15.00.tar.gz"
  sha256 "0c1a355b9010be46bd1ac79e6fe0f6cb0f08ddb3222228b76391f2172102f33f"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "20598a91e3204550da677d8a609fcdffd6c641c4ab765867f39879b4a4240130"
    sha256 cellar: :any,                 arm64_ventura:  "fc36eb1bde7a3c53616cd46200a3cd18cbbb79a0713cfbdee15d54d4d6b53d20"
    sha256 cellar: :any,                 arm64_monterey: "dc110ca3bdf071edbd152a6e435f49ce26c548b6b632fccf5b8ff80cc160d520"
    sha256 cellar: :any,                 sonoma:         "cf0759545b99f32f919fe411942ca6f1304eaef3d2fe5cfe0f3728d0e45ff1c0"
    sha256 cellar: :any,                 ventura:        "167b8afca2d91caceca6597524724079e231fce4e9d9ceec5e38a4fc25b01400"
    sha256 cellar: :any,                 monterey:       "321cb1e7be511c7f3ae5e1cc83c49775ef9c91a167010bd0f898cd629002aabb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd6e124778f5fc43ef48f510f6391ec39977226e9d5a71aadec7b3d1829a27e8"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "libsodium"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pid = spawn bin/"proxygen_echo"
    sleep 10
    system "curl", "-v", "http://localhost:11000"
  ensure
    Process.kill "TERM", pid
  end
end
