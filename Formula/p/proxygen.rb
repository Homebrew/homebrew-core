class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.05.02.00/proxygen-v2024.05.02.00.tar.gz"
  sha256 "0a82ee8fdc06de3df40473a6e973984e1677fd2736866cc728e9da3a8711ca0c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "245dfc4ba5c1c94327100fcf9ef9b7c72c44bdd1319c440e36afde2a485ecefa"
    sha256 cellar: :any,                 arm64_ventura:  "a86284a7ef67c8424138f185a7609e943b0c3a95e128522d30746acdc1166cde"
    sha256 cellar: :any,                 arm64_monterey: "7846825c7ac5f73491ce363389c11e52eebdf23e8d77c91954447cba16ab327d"
    sha256 cellar: :any,                 sonoma:         "a302bde7ab6874422c396de4fe4fa162b62290a81dc70e80e75f6710bdbb3ba9"
    sha256 cellar: :any,                 ventura:        "14cfc3f530f143f6902c2e6c42e0e08d407081d34899fe6e9ff9ed137c0850cf"
    sha256 cellar: :any,                 monterey:       "10276be8d98c69d55e9cf10dcdf54229596d696afc69e35b4a4ca95c6508d5ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b54c8c5e755c6df710bbdedd6294f1bfe86fbf8413ff44af26a6e53b4d591757"
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
