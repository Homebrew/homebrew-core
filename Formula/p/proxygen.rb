class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.04.15.00/proxygen-v2024.04.15.00.tar.gz"
  sha256 "7b21caa83a0304cfe5464387cb46891cfad90cdbd1f20c6f64a98ee656996843"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cfd36f7bffb681ef4ba9934c9e47cfe58247f44c7ad5db8f97bc7e4bbab9d247"
    sha256 cellar: :any,                 arm64_ventura:  "3a9c16cba54c8589f23256f3e49a013d0e8498bcb550ec1c008e9d956e7da53a"
    sha256 cellar: :any,                 arm64_monterey: "f96036d48d3daebadb3961f9811046596cb169209f850dfb4614df40cd0f5732"
    sha256 cellar: :any,                 sonoma:         "009ef923dd13e2c95187ac17b9765715cd5492e038ef88b963ae38ad275a9519"
    sha256 cellar: :any,                 ventura:        "abd5b74ba1f00793b3d9cdb90974da650f4dddf13e51dddaf083ae8ec296daa8"
    sha256 cellar: :any,                 monterey:       "71d6552f19a24b805894d78059372ddc058dea2d52b48a9bae77281b3821fc2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62dbc1361c6fd64faeaf6afb0bc8906658e128d81724d5e5cd03549480d1442e"
  end

  depends_on "cmake" => :build
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
