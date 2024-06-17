class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.06.10.00/proxygen-v2024.06.10.00.tar.gz"
  sha256 "a2bebfcab5107d6abf477e0bb8d391cbc8801c497bb851f2441767fc03cc7755"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c21e992ae973bbdfcb89fae05595004856867e5302167d0e17243b0614b9cc36"
    sha256 cellar: :any,                 arm64_ventura:  "a1263fed98b23344961c334690ec5a500219338cadce46f563a91e9aed325b6a"
    sha256 cellar: :any,                 arm64_monterey: "e1de88a37562bcbf3eab1c9c292f3bce2c5af89bc8f09153583b4fc46b7c4a48"
    sha256 cellar: :any,                 sonoma:         "e692377010c853f752e17666f88f6f58368d245207ab1933234e0e76998a61a6"
    sha256 cellar: :any,                 ventura:        "5547f5702b32acf31b1eca373998a807ddcffed018995054288fa9fb544e9752"
    sha256 cellar: :any,                 monterey:       "1b5ddd35dffa7c74b2a4ddc2ac4195d3baa3f7bea9c804b20164ab6206754e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4784ab402be02cecdfa7b9f42f8a13281c47fb91f2a3e4f3634834a374506c4d"
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
