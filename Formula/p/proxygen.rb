class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.03.09.00/proxygen-v2026.03.09.00.tar.gz"
  sha256 "e0fbc19c7f47b4d75d2b70a08c6d7dbd27f402dd3439d06a3c6e507cecc10c88"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "64ca0831030dca00ca5a433ae57fb270932d958ed0173884d78cc3db363c5f8a"
    sha256 cellar: :any,                 arm64_sequoia: "fa6624ef678829d571cc98288c4da4eaf8981b76fd9cf6850170b1e2f2432984"
    sha256 cellar: :any,                 arm64_sonoma:  "f59b509627842010d3d2e91f8efdacdbba22aa071fe07e67e608e5edcd2b4959"
    sha256 cellar: :any,                 sonoma:        "6e2ebf39e556767563cc417f4ebd0a6891ac66d7bcc592215522d04f269a1b34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0690ab9d5f9f063a063fc33e95eb3a9ae80eadc8b547ea7214a294b9d0d1371e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65bd7adefa9778bd591fdfc404eac66ac4d78d57da2878cd1ed784efc74a0a25"
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
