class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.08.12.00/proxygen-v2024.08.12.00.tar.gz"
  sha256 "b8d764fd509ab1a3c9d4dfdc4d0828576b84dc4b2252483846a62f9852d85d4c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "62570a8200fea7af37bf4d17ddd65be7ad980deba109df4938048aa85ccc84cf"
    sha256 cellar: :any,                 arm64_ventura:  "1dc32f24f32ea97c0d3b3f83de595291f5afffc3c63c6c53ef794127a27f3b99"
    sha256 cellar: :any,                 arm64_monterey: "45c0f0764d4515b5c12def3011d4ce889378d9bd262a2a14fd2860d29d1cb575"
    sha256 cellar: :any,                 sonoma:         "86239ba4acc545fcc4b5009fe8887964b85a271c08cd18fe4333cd8316363e25"
    sha256 cellar: :any,                 ventura:        "cae35a5ab035eb79707cc31e71b4d2328b016ecee4da5d9ecc2ef963416faa9d"
    sha256 cellar: :any,                 monterey:       "f52ff98c5629d9ec51b8fde5300648d10788e20f396274c625eabf3d2dd737dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "999e45a51636b410fe30cf3a57d680644b1202871724dae2622186b9f79bed11"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "libsodium"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
