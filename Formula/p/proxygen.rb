class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2025.11.10.00/proxygen-v2025.11.10.00.tar.gz"
  sha256 "f0c43c542d0db9ec83523394309b06ec9f054fbc886408fce473ba9c8d1ea819"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "99e6b8f1bd6ccb4b7ea93557a52ca1227ab3191001336ba32b4e982b2dcab237"
    sha256                               arm64_sequoia: "e3436e6b09314651fb4c177a8b59db11dd45e0026090b778d26f8f3509d60f76"
    sha256                               arm64_sonoma:  "8da390ad7812a328dc68845e4a5fe9bde8157d22eb0d18916548a128f76b7a95"
    sha256 cellar: :any,                 sonoma:        "a54f9822d9855419f78c1b6796ac0e4bc1cc4cd56d67bcc81f13d4c0cff3d2b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f369c238e7e3246c622e52c012e35b2e3b01289c64c10c62344e965f44799e08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76fc5d9b1cfc9a76b8f160395e2eae0ad8037835c27d07eac6066a67d79557a8"
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
