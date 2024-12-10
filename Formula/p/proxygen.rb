class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.12.02.00/proxygen-v2024.12.02.00.tar.gz"
  sha256 "536c5baaf372a590e848d1bf60b46195bec421e2f940034530e1c170d43c4947"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "21df603f5e31c3a3194c53139cb93426316256a231bb5fb1132d7c14d6f1f68c"
    sha256 cellar: :any,                 arm64_sonoma:  "310a42d4f43c473c7d567f2defd4562a9c57b81ef2c759cb7aa23b1e2ff349c4"
    sha256 cellar: :any,                 arm64_ventura: "e8b2621ed173ffe92d39c57c5b346ad5c1110455d05e88348fc889203ab05dde"
    sha256 cellar: :any,                 sonoma:        "5b57f285fdf57f255db5fe0c118baf5053fc1bcf5413506dac17f5b37811cbbb"
    sha256 cellar: :any,                 ventura:       "d058fea88e91626ad70967c66b73c26b816f4eb632385a44aac0c9a01ab90446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "300a8af8e2362949795c88d8b9e32b0a493cca0aa47767a1696da3d6e86c0cb8"
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
