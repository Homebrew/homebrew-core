class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.04.29.00/proxygen-v2024.04.29.00.tar.gz"
  sha256 "62b48033cc96e9e0aa3c43e3c2cb6d6e8da1027be81c4202d27d8cadb9d87786"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f26eb03944feaa152aaf0ce6224e9a43ac87ec9f0711bf456b46e8392dbef78c"
    sha256 cellar: :any,                 arm64_ventura:  "b88c68ac4b2f2e3f90bf565f66f88738d4293992490fbe5b66ee703ab7565b03"
    sha256 cellar: :any,                 arm64_monterey: "4ce04182e000707978710d12ad4ae99d49547f4d27090222c894ff73c1a52b0a"
    sha256 cellar: :any,                 sonoma:         "9d9a8a8e03e4c1d3669182116e4950a0de9fad44504bb8c678de66698e34eb69"
    sha256 cellar: :any,                 ventura:        "84a29c3e3194ba5b60afebbc6d3dcc53fb9fae4fe76d389165b5b5e6fd7b2802"
    sha256 cellar: :any,                 monterey:       "149af00a361ec309b2763180c91f1be2e7aabc6f5e16586355a4c0e952ad486f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acb9fca6aa8c7eedc1092bc1936e8ebdba1b0952a535437b857095993a366a1a"
  end

  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "libsodium"
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
