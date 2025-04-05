class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2025.03.31.00/proxygen-v2025.03.31.00.tar.gz"
  sha256 "1a17c81ffbbed6fc0c99c61b5f885aefcc6f1a16a49133e19cbf16b3dd426a23"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "37f7ed23ea37313cac665d08ee556091a47dbd8d52f6d7043a11a45fb3164a42"
    sha256                               arm64_sonoma:  "08bc67dcb4e71c370dffcf7c0ec6ca41f44871ff360bed7195f788b7b3a982c9"
    sha256                               arm64_ventura: "a567674fd8ec01290ee7eeff7476421f6d001f42c01bb6de9c4bcb320164e2f7"
    sha256 cellar: :any,                 sonoma:        "c28f521b0248d827fae680bd54cf162c71a749f7f8bc68cb4c871e66136d7476"
    sha256 cellar: :any,                 ventura:       "8194693bb2e3fc36925a1817caecfb77b46aa336982ee0f4a5d57c17794ebb82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6634df1d072a4232e1f9cac2c31455ae28e76fe9e6e59ede1e7b2d6cc4cc0ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50d54dce624c0a4e861911f49757cefc1efec0446a3806975de78afc2a15c318"
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
