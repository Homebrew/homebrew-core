class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.04.20.00/proxygen-v2026.04.20.00.tar.gz"
  sha256 "fe2069f8a2ab1f3beedc46a20d4abd88f53a12dc3b616c225d897796031af5a3"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3de5492aa7f38be04ffdd90e3a227494425d9973376b2e17a034a8230309f8ce"
    sha256 cellar: :any,                 arm64_sequoia: "6b2d41e4bc49aabfec7ce858bbb2c93032a81e702bdbfbacd3bd076667201762"
    sha256 cellar: :any,                 arm64_sonoma:  "5a60bb2b0a37fac0a5bf1127f75cb17003c3bae2c7f42b30183d3bc68834453f"
    sha256 cellar: :any,                 sonoma:        "36eaf52afd0bbc58c9dcadc0239c1762dc730416e0ee796b53759b26295a910c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bd24e3d6a1848ba4b27b60e4ed299b7aca441447d8cfbac9562034c455bca95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bfd5ba27830f84bab6509f8c3cde5187b475c75c89cb38d4bb032c58afa5062"
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
