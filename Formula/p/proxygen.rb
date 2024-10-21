class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.10.14.00/proxygen-v2024.10.14.00.tar.gz"
  sha256 "630f2753b5832c193d0e3aee3f0bc47cbee404c674bbd0494ed4d1b969d16f26"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7e8176219a307f79b24eaa5b658cdf4449b2cc32aaf90a9fab2d768979c02f69"
    sha256 cellar: :any,                 arm64_sonoma:  "61e06fb68d0bc6f73d0680e01979b5820091671d161c0834ec5ee45a3e872726"
    sha256 cellar: :any,                 arm64_ventura: "b58cadba18bfa135c0cfb9c1299d9412d724fbc73e05b0edee05897a242606a3"
    sha256 cellar: :any,                 sonoma:        "60747b76386f644dd868a57b400ae1ab257ec9cffbf57e48b7dc93fd6eeb4e90"
    sha256 cellar: :any,                 ventura:       "aa9a88207bb744fdb775f3a2352a8e5cb6fcd30dab1f38eb62ba71111970ccbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35c9bec49f7f4ad7e506a808f4618664c71d1ad2699490c94a6e00bcd0bcdc8b"
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
