class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.05.11.00/proxygen-v2026.05.11.00.tar.gz"
  sha256 "4f8ce2fd4037cef51707628eff7b4ef489fb322308913e9b346c0f070a0ac9df"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "77b88f295d31d84664b5b08c697e257e407ef1b13c2f855d11bf274b1addb33f"
    sha256 cellar: :any,                 arm64_sequoia: "eadea2543707770262aa7d02bd441afc0b53ab34f11422ac7cb91f424333f956"
    sha256 cellar: :any,                 arm64_sonoma:  "082217d7487da85d40fb8172687378b92418a5ab50958fe0e57540528c41bbbd"
    sha256 cellar: :any,                 sonoma:        "c699ffef2f010d23781859ebd6530b925d7ba6696dfa0e6198e7a3e332722404"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab65de56de830a2d712a79dd4948a6551d388361c820e87f7c2ac659a429677a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b405c739bf0c08fbeb3a846fd7067088948794171e6c615942eb25ba91913a96"
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
