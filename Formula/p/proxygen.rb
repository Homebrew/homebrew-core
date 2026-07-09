class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.07.06.00/proxygen-v2026.07.06.00.tar.gz"
  sha256 "176cf9d7647065674774e531594cf609d13031f7ed2152b673bf7ec583a6afae"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2cdc092f6be9388f80b1ea101d75d7e493f95db6adf81a80b8444c9fcd7cbdee"
    sha256 cellar: :any, arm64_sequoia: "6627d0c5185969d8977f0291ed946047721e5abdad428d9e51341f6c882623fa"
    sha256 cellar: :any, arm64_sonoma:  "f9d4cfd48e6224f7ffe2038f8594857f0c4ba15bd56670a571326437972474f4"
    sha256 cellar: :any, sonoma:        "71fb866e6254305656867ff1a575e4c4f3e811a7a2b5a273e2655b10e61d5be2"
    sha256 cellar: :any, arm64_linux:   "1d03203b5b71f700ec7c85cfeee113417eb9b40021737f3090608c573faf2a08"
    sha256 cellar: :any, x86_64_linux:  "ff3240ccd7b7442b4f94be5e7312dcfaf56abc3daa22851c6d7187437ecc01f9"
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
