class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.10.05.00/proxygen-v2026.10.05.00.tar.gz"
  sha256 "53315c7dfbb805baaf1f8eafc7b9830f7c7dddad29f4f4f7dd748313aa54d635"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c18240c15ac0a0d50069b06d7908ca48ecb05e84c11a4b5226d30dd25ffd71ac"
    sha256 cellar: :any, arm64_tahoe:       "43528156fe18a1dc7d8a8e337628365a4e2dfa3e19a5a7fa59ee192525727442"
    sha256 cellar: :any, arm64_sequoia:     "268ab55fd737beb82f21c8fb374c04501ee42b805f81b3f9de7fe7cc2b09815d"
    sha256 cellar: :any, arm64_linux:       "670672f27163171533c3d6fba5dd7e71cccd9c7c62e6557c782d42854f864dbd"
    sha256 cellar: :any, x86_64_linux:      "83a2cdb88d58d9bafa7a632c0fdf8840843cba5b55344e1f57479bf6290ea4fc"
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
