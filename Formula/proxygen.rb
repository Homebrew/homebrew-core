class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2023.07.03.00/proxygen-v2023.07.03.00.tar.gz"
  sha256 "cc136282c73c88fc20e5abe37c1988b86613737689b549d37524e52a82f2e689"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9250a18b47fa85134a11362f73b6fec19c7113fb471a64f10331724c9300ca89"
    sha256 cellar: :any,                 arm64_monterey: "3c45a205332845c51a3463531134cc6678aa0c3d89b3443939c99f846ce8ab0a"
    sha256 cellar: :any,                 arm64_big_sur:  "379497875b0a9c6bcdf640344ac2ad0d879c381f973b9544981940710e73fb86"
    sha256 cellar: :any,                 ventura:        "e86937f9edbb869fcf3f51cd3339e43f4ff5fb9b67f7bfe02d9b09f6731fa29b"
    sha256 cellar: :any,                 monterey:       "7bf156272badf30933f94cf478caa7a541306ea3519c1a1d1c92e4ef9a96df41"
    sha256 cellar: :any,                 big_sur:        "0a057eb37bbcf72c55e4f66e99200e11f07c04388b1ba7b954412c05ebcf21e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06d20ff81f873b58fa1dacb0d2ec5c87b804d65fea2cedaec7177cb5a174c38f"
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
