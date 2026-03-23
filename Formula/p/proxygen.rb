class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.03.16.00/proxygen-v2026.03.16.00.tar.gz"
  sha256 "c41875c32196f9c5529b59b03267bef99d1b8d6581bb340a4a27a4c287c8db02"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a01dd7796424ac5d08d15ac2f4b10a8937024461fbce27bfbbdbb01cf9eb8298"
    sha256 cellar: :any,                 arm64_sequoia: "4488ff6f5b1c1b1134592bd28ea9b01f034af3f25ca743edc410e7f2f7bb7013"
    sha256 cellar: :any,                 arm64_sonoma:  "bec203827b1acc55b1a1d35f4d954d5a6546697354684cc12423d7dbc23fb7b9"
    sha256 cellar: :any,                 sonoma:        "7cf149a73b17add019dcfd89dd723d2a6d60dcfeb60d85e95bf2f47a40941a61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eae5d64538579e0abc0df97cea8f6d3a7e05447701c04a7a759b6292041bfcae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c4b7d31d1b77bff6606d59e91ed4552d0a0a90e2292636a9fb0f899af54c2ff"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "c-ares"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "hq", because: "both install `hq` binaries"

  def install
    # FIXME: shared libraries are currently broken
    # Issue ref: https://github.com/facebook/proxygen/issues/599
    args = ["-DBUILD_SHARED_LIBS=OFF", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
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
