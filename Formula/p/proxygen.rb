class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.10.19.00/proxygen-v2026.10.19.00.tar.gz"
  sha256 "ff71e3fe818424ad84da33ca576801237f0d35feefb27946a859595a0937386f"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "043261b547e7696b1a7c772f64f08c771b8e6d20ef1628ddd27ad95a103b237a"
    sha256 cellar: :any, arm64_tahoe:       "83a60448be15029c4228c2a3629b6516e9102784cd6bc9a27691491e31129bac"
    sha256 cellar: :any, arm64_sequoia:     "6f3ffcb0708a28be0cd355f000ee8ac8ba82a5bb4efce8a47aa7419170dc309f"
    sha256 cellar: :any, arm64_linux:       "f886c7e450db42def936798066ea51100172fb874bb605a1db82cea947dc397d"
    sha256 cellar: :any, x86_64_linux:      "cb37c9d840c5cf937bc0f6068cfac3b3d60304f41fb66c3b2d8323160fb842e0"
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
  depends_on "openssl@4"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "hq", because: "both install `hq` binaries"

  allow_network_access! :test

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
