class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.01.12.00/proxygen-v2026.01.12.00.tar.gz"
  sha256 "66364e2119618a98f5c3ad62765b53d8bc2c34a9e51e0e861345aa7a5e87414f"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "b1557624e624a7e8f42032e75c04fd22a0ee0f2e54a26fcabe98f0e7d7fbcb3d"
    sha256                               arm64_sequoia: "b7b3e35457beecc359134146728539ec3448df14ed679f733195ac4aba162965"
    sha256                               arm64_sonoma:  "a6f3d9f669d3fa0ae57cf38a7f49ea852ec0579e87836ca214982a68192ad75c"
    sha256 cellar: :any,                 sonoma:        "cd5a5001d7606a3fac04c0765874b5aa8faa7fbd742c48d210a205bc54f60c21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e576d6d52312503927f0c7b18777c3973d659c67a51452f0ac601e076ddaff99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e35ca8a550df9ab8636b6121a2e817872e54df995dc4c4e5257abf34b99e956c"
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
