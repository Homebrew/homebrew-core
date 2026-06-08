class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.06.01.00/proxygen-v2026.06.01.00.tar.gz"
  sha256 "be8fd10646c07b1fa4b37dfc2328f27f80912de2f6fe9a2f91c6cc496c2a0ea1"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "438139f15f9edba9cac63ca7bb1cbafeee53b57f6fdfa9d5db51d044642e398d"
    sha256 cellar: :any, arm64_sequoia: "73cd2ec0e900df93b849165d5ffd6c4aa1607703d4b588ce7147a4f7c6de33ba"
    sha256 cellar: :any, arm64_sonoma:  "99dab02dfe21024b02f53ec675978f5c6bf8a5d78a29fcbe2fd5ec8f006e071f"
    sha256 cellar: :any, sonoma:        "e14101ee6a20c1d0c81e5376189e076698b418db85275280e28c5c9d954fb1ff"
    sha256 cellar: :any, arm64_linux:   "dc29514d25a161462609809b36161d740cf4c33d200cffefd29440c450777b28"
    sha256 cellar: :any, x86_64_linux:  "39e6db32fc1b808afbafec8b8da45d105ac9b2d3e54a59a2f5ee170d88a0acbd"
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
