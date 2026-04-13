class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.03.30.00/proxygen-v2026.03.30.00.tar.gz"
  sha256 "3094c73b1cf99abc8c1d55863b5958b1209ffb5fa8a3fe475769c86453fc4138"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1990f4030aa08dabd3399c999a9ca1c0b77987a06d3d33a8faff2724f95a702d"
    sha256 cellar: :any,                 arm64_sequoia: "0fbb6970ed8a6b18e6158ed999cc03ed96fc55072e932d2096e226841597dfab"
    sha256 cellar: :any,                 arm64_sonoma:  "b697f15eb742df868a4530bba328754c581957ca6daa3c315c415fcaa2762ec0"
    sha256 cellar: :any,                 sonoma:        "bfae8119cd0a2e7d3a993f95456fe4051f8810fd588f69f02a4c294bf9abf68e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59eeb851a3779cd0e48fe4b703b105f1282859b8b5a14176d6bbe9cc398302cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e444e2376b76866c74fe3bd1e701526bd5d9e38517d3028d95660f51dfbcb52"
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
