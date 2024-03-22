class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.03.18.00/proxygen-v2024.03.18.00.tar.gz"
  sha256 "060277cf32309fb0c0a1a5fca772500015ffb53a3b9f31534aaa50d27e80c9d3"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e4bcb42026bbf5cc8c885e35c2de3b24f14da212b9eca6773ef2b13fb30206a7"
    sha256 cellar: :any,                 arm64_ventura:  "7674f3cf509ec807d609b91a3b271b9e1db2df1f3b66344d288b513c05284ae4"
    sha256 cellar: :any,                 arm64_monterey: "f963a326c6250f085591e9d2e28f5c4b9c71ab7c4ccb03bfb05c831be9483393"
    sha256 cellar: :any,                 sonoma:         "4c2d0743b84d64f4d85987960316f4ec5718323dd1e53dda22ef010c12431c92"
    sha256 cellar: :any,                 ventura:        "de9ac9a7558c3dfefa318fbeedc614c4041fbf5fb3a97695c807e9e67b8395a5"
    sha256 cellar: :any,                 monterey:       "10513c7f4d9f937721c712d35a461fd46790094d14146dedeedf8065e2dd7b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "837ad7fa408338c4a4d96bf944283be27b16de117ca7f35f8ce83cac64fa3d92"
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
    sleep 5
    system "curl", "-v", "http://localhost:11000"
  ensure
    Process.kill "TERM", pid
  end
end
