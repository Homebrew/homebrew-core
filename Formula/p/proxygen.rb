class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.07.27.00/proxygen-v2026.07.27.00.tar.gz"
  sha256 "f9293844b00001549dcba2c10d453ccc2af268a45b52a31c622b543ee0cfe7e9"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "969cc065653958e34e6e69e774e5bac9462958bb02d7b33b2f964aa8a2b0ebda"
    sha256 cellar: :any, arm64_sequoia: "7bbcd2f81d69dea5c5563b36b933faf36398255e7f439f01a1ff95b11d374bf0"
    sha256 cellar: :any, arm64_sonoma:  "5d52bf0644406a742adefe8aed3d6c00f4b308e6e264c639d05ac8346592305f"
    sha256 cellar: :any, sonoma:        "6a117d96fb0b944cb5f99a6b43c7d5d9727d33b232cfbb6dd6cc07c749e6a81d"
    sha256 cellar: :any, arm64_linux:   "69679b7f048fe80b8884d3385a6ac5729c9bc68aa87f6c6efdfec22e844e3db0"
    sha256 cellar: :any, x86_64_linux:  "02bc3fd314ae4743c21a57c05070b50d26e482b51df93c0346b0793d0e2eb9fd"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "c-ares"
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
