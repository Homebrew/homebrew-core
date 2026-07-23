class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.07.20.00/proxygen-v2026.07.20.00.tar.gz"
  sha256 "ae6c61bbd57dbe0a8623abdaab72dabfd9ec30fb39a3e8e2ec37e5332f4dd8e5"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "698b62c7d624ab54c3b816ab640b9e641fc2ea42b5b3fe8b08287cef5339a2ba"
    sha256 cellar: :any, arm64_sequoia: "7c4f1c52f1bdb40b369fada58faf57178e4c2b5915b31d4848894db650495223"
    sha256 cellar: :any, arm64_sonoma:  "1ad6fd4e449ebdc9400fa4660319987e37cd72231144dacd8b72293a65ca5d0c"
    sha256 cellar: :any, sonoma:        "89605488537c6225c1a8cc99ac43ee24ff92ecb3060dcdaf032b8b7419cf0ca7"
    sha256 cellar: :any, arm64_linux:   "d509aedb8997250befec3cfad26d8643d8c4fc72aa64f87fda54dbdaa4fdbaed"
    sha256 cellar: :any, x86_64_linux:  "37d3c129e593ddf7eeff06f44c12e6ab048f5083907a797611962e1f5ca93081"
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
