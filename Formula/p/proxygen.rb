class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2023.09.04.00/proxygen-v2023.09.04.00.tar.gz"
  sha256 "e4db076db908b003a23ac139b6c433d8c34daa77cbdea33fd5a77bf9889dcdb2"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "86f38aa566e1e3fec2eb3fbd585a6ddebe12624dca85f0918351525ced1eb689"
    sha256 cellar: :any,                 arm64_monterey: "1e2c173b1f6972257429c20b37f46fade0d45b44b58a8c4404a594a92f3d2f30"
    sha256 cellar: :any,                 arm64_big_sur:  "928e10f18b90dfe8f7f42a17ded12b9ba92ce570ec91190b8f31f2b927433b27"
    sha256 cellar: :any,                 ventura:        "6d83eeb05592ab736819aaf6d6aa810629e25041dc9107cbabd76989de4be682"
    sha256 cellar: :any,                 monterey:       "b17d9f13736546a7cd4536f7114462f486adbf97fda17a3a7a3674422aa427b3"
    sha256 cellar: :any,                 big_sur:        "997ebab9681335b690971c907ccf04a60c0b20897339df286efb7854b0c0b7d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9c57cc16f8c014c2358b8f8f93461dc8d4c1b9826df4bf1f2374f02f10dba9"
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
