class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2025.03.03.00/proxygen-v2025.03.03.00.tar.gz"
  sha256 "2060997bdb9729bf5c4f32201d9bd9af2f6f4995913b8c033c6706f481908ac6"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "14d3f0b582165b160792fa04ffde21a40874f3d5e282c5930085611e4335bd27"
    sha256                               arm64_sonoma:  "fed498dceda89cd714e4ec2df05975f31ec5a1a8caff073517905de5cdb805e6"
    sha256                               arm64_ventura: "cc8847ebc499ec09d4e07851be88ff423a232e637f186b18db7f345114e8fe9c"
    sha256 cellar: :any,                 sonoma:        "1ede2eb401659650e50703a1925cf8e4904639321f29010dbbb350ee7a2c19e8"
    sha256 cellar: :any,                 ventura:       "3e9673c7acbffa7ae599565efbf51a74657374fbbdc68aaac4e91fd1534d5995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb9dc6f27d5189bbebc64728bdb6671e183390d01ab285e9cccf73a2120b3b5e"
  end

  depends_on "cmake" => :build
  depends_on "boost"
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
