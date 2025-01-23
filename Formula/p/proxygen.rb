class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.12.02.00/proxygen-v2024.12.02.00.tar.gz"
  sha256 "536c5baaf372a590e848d1bf60b46195bec421e2f940034530e1c170d43c4947"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab0e64dd6b371856c7a8598b7f66ee5920e0c3c37d05ca4eda765207ad7c4047"
    sha256 cellar: :any,                 arm64_sonoma:  "64ad913f51b4365cf771497c9c7b3115f5346eca6fa530a22d0db68624737da1"
    sha256 cellar: :any,                 arm64_ventura: "7520450e26415df4ca957231748e8ead397c0147ecfb31b40caeb871e74c5a81"
    sha256 cellar: :any,                 sonoma:        "5d650979226a82a089e3214c0820dbe2217f74139b30121deb2366e5a41c6d46"
    sha256 cellar: :any,                 ventura:       "7379788150ae2770facc43e892d39444a65fe7239794d82b4f055c5006bda411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6195400434334fc8652e881b28521c417afac224a1b49ffc7702fd5cf431914e"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  def install
    args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    if OS.mac?
      args += [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
      ]
    end

    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    port = free_port
    pid = spawn(bin/"proxygen_echo", "--http_port", port.to_s)
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?
    system "curl", "-v", "http://localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end
