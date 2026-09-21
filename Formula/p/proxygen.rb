class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.09.14.00/proxygen-v2026.09.14.00.tar.gz"
  sha256 "e539c8bcb9a3ebe0ac71ef0ce4bf645508dc84404029c02b28bdde38e07c51aa"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0d10d6a95f62731e42598c8f22316cfaf9f17640a1922c3b06dcedcc8cef4acd"
    sha256 cellar: :any, arm64_tahoe:       "a3ceea1a68325cf1eb541a13ca8745c610d5ac9b598e4ea1e9723fbf63b4caa0"
    sha256 cellar: :any, arm64_sequoia:     "49ffa2a1dda9853044500df7e3f853622def4694ab4e2ebd4561ce5ddb47424b"
    sha256 cellar: :any, arm64_linux:       "1f4846fa722a57e368e6d4eb733c208710b6330c15bbeb47facab6e0efcc4674"
    sha256 cellar: :any, x86_64_linux:      "c76f23fb08924fcbac877a62668dc15abfbfbf457e7477bf5c7ffe8d2ab9aef7"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "c-ares"
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
    system "curl", "-v", "http://localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end
