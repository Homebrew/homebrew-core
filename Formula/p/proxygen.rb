class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2023.08.14.00/proxygen-v2023.08.14.00.tar.gz"
  sha256 "b7f1d2676da63fb1868b84331b7b9a7e8f15cafe496155554c67da176720f7b5"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "86ed139ca5916907dfbb35a8ba7d45d6c52d8cad068d6ba1d147b7ee889f64c9"
    sha256 cellar: :any,                 arm64_monterey: "ee3b273b198a8dc4624a2f02f440adee2c0b4a1b65ac74e664b7a154c07023d6"
    sha256 cellar: :any,                 arm64_big_sur:  "70b54af3ffd87369e59778d9c4c6dd878ea989eeaf5e57bc40d39fad54a9f686"
    sha256 cellar: :any,                 ventura:        "67166dfb207e984e9dbef43b9c3349c4d543159d14b4551b4645eae55a2fc904"
    sha256 cellar: :any,                 monterey:       "0a389c5a1e7d39215f34901ff3ef26f514a6bda30e4f95aa1e807074e30db2f2"
    sha256 cellar: :any,                 big_sur:        "9778ed394c4aca9b132b8dcee2d523663ea78687cbf83e8db7baf31e5a3bd984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f07586b9a71d264aac6737d1326721dcdfbc1204c4228337dc00e4066908aa44"
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
