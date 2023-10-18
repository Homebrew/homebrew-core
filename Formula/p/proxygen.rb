class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2023.09.04.00/proxygen-v2023.09.04.00.tar.gz"
  sha256 "e4db076db908b003a23ac139b6c433d8c34daa77cbdea33fd5a77bf9889dcdb2"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c2dbe0929a15bf044c13f7ea81640eff6a811d6cfba58fe794907d6dca2afbcc"
    sha256 cellar: :any,                 arm64_ventura:  "a26b4802c745cb7e377703f45ad0cc4e537251cf8808e64f2ebcf58862bbbcd3"
    sha256 cellar: :any,                 arm64_monterey: "9cf3bb099c1138eac2c9e1e40f53e967d4a1ab50aba1e18bc2be46935582f3c7"
    sha256 cellar: :any,                 sonoma:         "5b6d6a4fa8e97c4718e9d8a1f3465c60b52f24578f77373de612d09f8841463d"
    sha256 cellar: :any,                 ventura:        "0cb918d9c2dd6706afd8bcebc63786b30eb40cdc6cc5229bedd38dfcc9b16190"
    sha256 cellar: :any,                 monterey:       "d831ef95873a1f8c008b729104fd542942e16143d49745992e55468c13d1bcb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36f5761fb73e8a5b51fd799448f661ab13b75527500ca7697b00f230ebbe9bd1"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

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
    sleep 5
    system "curl", "-v", "http://localhost:11000"
  ensure
    Process.kill "TERM", pid
  end
end
