class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2025.11.10.00/proxygen-v2025.11.10.00.tar.gz"
  sha256 "f0c43c542d0db9ec83523394309b06ec9f054fbc886408fce473ba9c8d1ea819"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "9c05a4a946533af36f72dc84716daccaf556f0ae04661c1077f36367576eecc3"
    sha256                               arm64_sequoia: "2d3f6834cb9affec266a4ee4fb0bcd88f4ad244aae52f40270739a474a360b8f"
    sha256                               arm64_sonoma:  "88e0d60fe288bc5af16018a9a4ccb4ca9e3cd76c5d38fe8a0308e88559991eea"
    sha256 cellar: :any,                 sonoma:        "2c8b204c481635c2e11c722327e2ff6e0a8fb9d9b6d4cda40e825456f43ef485"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58a1892d30151151e4d3574d8a4db926bac8dcacb2905722961ac79a6d77ec9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1493a8752d0b5e6c3ab781a2a4ec63d0478650c6c5afd2415479de12f1ae4811"
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
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  # Fix name of `liblibhttperf2`.
  # https://github.com/facebook/proxygen/pull/574
  patch do
    url "https://github.com/facebook/proxygen/commit/415ed3320f3d110f1d8c6846ca0582a4db7d225a.patch?full_index=1"
    sha256 "4ea28c2f87732526afad0f2b2b66be330ad3d4fc18d0f20eb5e1242b557a6fcf"
  end

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
