class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.10.07.00/proxygen-v2024.10.07.00.tar.gz"
  sha256 "e2a7428b4b81e5237997293e60d1ee4ac5568f39fbe24adf543df8f85c782307"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f818ebc5d17f533dbd8b437a7ed6bd69fb038be2667144706ebae27806eb2fd1"
    sha256 cellar: :any,                 arm64_sonoma:  "96b805244fa346b92a6b5cca8e53f1b43b79c83aba9e683fecc52df3c3fed4a2"
    sha256 cellar: :any,                 arm64_ventura: "9f4af61314e96c8fe43f93c8ecada3ae9af2e8f726471ad9f1b54a2e46eb158a"
    sha256 cellar: :any,                 sonoma:        "5db62fbd8b20a35d7137fc682bcfe98a5f2c1f1d0ac4dc13a2e033b70d2183c0"
    sha256 cellar: :any,                 ventura:       "f359cba0d8b31e0b2ba8f40c3dec1643a012c1d7951be08c461ca1b049210b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "646a063e3563e9cf366a52dbe166e1aed5c9adb27184d62956b34371ec6ee633"
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
    system "curl", "-v", "http://localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end
