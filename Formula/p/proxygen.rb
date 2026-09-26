class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.09.21.00/proxygen-v2026.09.21.00.tar.gz"
  sha256 "7144f76b1a47424d82a432b55522f7391f7fc3b5d46214238b1bc3ba4d529476"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/proxygen.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7f524b8f0ce18e7cf00a0d4f480c5cae2e969e92c8c7776198ecd75a1351d681"
    sha256 cellar: :any, arm64_tahoe:       "4b1177dae5a1a001ffa564def269f2f062f44ba3b461caaeb88415e6b332b020"
    sha256 cellar: :any, arm64_sequoia:     "a8044c2ef145cd65505518b95e11a8d70c3b36c3a74f31ecd3bca91b79f8b761"
    sha256 cellar: :any, arm64_linux:       "1611b300100c53e3072ab6b40479a1687074c360a4fda2d42b07d56660f6d484"
    sha256 cellar: :any, x86_64_linux:      "eef748c0d9500ec32d1b1ea63ff11ce69415cfedee942bb4e915ee8330e38033"
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
