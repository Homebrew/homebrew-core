class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.06.22.00/proxygen-v2026.06.22.00.tar.gz"
  sha256 "0f0ec174f224a1965b12eb16d85ef835ac758495d05b528a23d8d9325e3bbd6e"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c662493c17cdf95778712b06ac3fcf05de21755da63038cf356f042e5207258c"
    sha256 cellar: :any, arm64_sequoia: "3aba97fb52bd7b99fc68979ae3736dc34b7c91ce6f17063c80d7f8f26f70a2f0"
    sha256 cellar: :any, arm64_sonoma:  "5dfb016b566b2cc0f43bc70f3b733af73c2311ce579aca0bec1dd719ee819e09"
    sha256 cellar: :any, sonoma:        "188689d7e7ee51d0fe0500e45e18c6f97517924bff94942f47efea9ddf3b2a1c"
    sha256 cellar: :any, arm64_linux:   "6f4dd91e9ebf1db35c090057106e400f752b915fcc0a2101b7050528f5515ca5"
    sha256 cellar: :any, x86_64_linux:  "9053cf455e0197474e680140559b13d02907e16d98dd2019bd080ca97f4b3f96"
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
