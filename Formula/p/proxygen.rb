class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.05.04.00/proxygen-v2026.05.04.00.tar.gz"
  sha256 "1f42b824552056af697c161d4f8683884066478d34f809fd5a2b2bb305e600a9"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fdf161011522c27c673d4c0d7023d6a5a266b0b041f3a7a49c8773e337e01363"
    sha256 cellar: :any,                 arm64_sequoia: "1dc65de4f7c94e0d26989fd971e77953bebe1990c7599e77ddfcc1aa55fec40a"
    sha256 cellar: :any,                 arm64_sonoma:  "7837eab2755ebb6df135777f46fdec998cd9a692d2213a62fe772ba799c9a5f1"
    sha256 cellar: :any,                 sonoma:        "aa4e297e6c145119cafaaf25bc6aaf2621be5ccde0a3a7b50d3e2ee8525b4be3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aaec18b1fc9774a4a9a6de2c98628bd19a6a0b5b5e28f313234c64d1a7c2c66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cd21787435051fb9d6747ef81f3fa6f75c0e0b43252add99eba12961760e73b"
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
