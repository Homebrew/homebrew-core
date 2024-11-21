class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.11.18.00/proxygen-v2024.11.18.00.tar.gz"
  sha256 "c344a522ed792e9d7ecfd866319bec3d8145ec774f652f508caccfd1871144de"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89697830785db1bdb668677c253f33c28bf030bd8374283a8a2178022d80f606"
    sha256 cellar: :any,                 arm64_sonoma:  "394503c4f13a04b08fd0a67ac371692a8638dda1db212e6b7ead41cbe58c2c3b"
    sha256 cellar: :any,                 arm64_ventura: "8a823f77463dbe8bb87f1db1caf8a176a8cfcf078e3c394ef5817c56a6cd7ef3"
    sha256 cellar: :any,                 sonoma:        "845f58372741845a9b0ec4be5dcf14db728cf5e09f65536107f001d9b6459d43"
    sha256 cellar: :any,                 ventura:       "13aa5bd936ff0e424785000df474b22cc99800f7cd51a9c4a89a457fd8f9bb3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2a6538dceee4e650b0a1d0dfe14cfdbf23be2faddb266fbe8b5d809356db89f"
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
