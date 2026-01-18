class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.01.12.00/proxygen-v2026.01.12.00.tar.gz"
  sha256 "66364e2119618a98f5c3ad62765b53d8bc2c34a9e51e0e861345aa7a5e87414f"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "c178002a13c95098e3a58cac0084c771f3196b3a129f7991242c24f029001402"
    sha256                               arm64_sequoia: "7806f97accabc8c9a66337bba0541234b75250c91074d8be94f93134f0ffae6f"
    sha256                               arm64_sonoma:  "68655f6aec7a1ada32b78eb48e426f1f43328d0e332c242de4511082675a9680"
    sha256 cellar: :any,                 sonoma:        "8312433e40a7b758647518d363f0d52a412c8c5af037fd3fc9c248f893ce5c6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "410a0a2f7b7e004a88eb219a1bf8195d060cf397c994623de7529f7266dee7dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a22521961b90d6037fc3bc2143b45e618da1be27764d74796426319193528f99"
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
