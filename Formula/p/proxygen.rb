class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2025.04.07.00/proxygen-v2025.04.07.00.tar.gz"
  sha256 "e76073abb0a3d70bec267038103b45c3f31c5d6012cc53ed5f8386acfea7789b"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "56bd8821cdcaeb372af4d79f38a2412717759eefb44e608e72d59a7e92d493f3"
    sha256                               arm64_sonoma:  "7e9f234a3d93c49754c6b4102aff0ca85f36a477a5c5b74d979ee14bbc8975bb"
    sha256                               arm64_ventura: "a8c132fe8d618a9a34911187711754c8385a199e04b2c3b7385da2c2d8da7931"
    sha256 cellar: :any,                 sonoma:        "b5acadb684b55dd114141f64ca7f6a9c74d33cc933d63a8c570c56b9df632b44"
    sha256 cellar: :any,                 ventura:       "08bb0212e86d7972870c8cf54738553a0c0b56dc428d9e59c5e43e19a4f5b4e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9c7c2037a508b34c8e363b551e7fe50a849c2e3c113083433651fb32da14022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b55b1060dac1fb5877d9f7b655239ae01c259f68490a2d6ee8e369e77604039"
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

  # TODO: uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  # FIXME: Build script is not compatible with gperf 3.2
  resource "gperf" do
    on_linux do
      url "https://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz"
      mirror "https://ftpmirror.gnu.org/gperf/gperf-3.1.tar.gz"
      sha256 "588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2"
    end
  end

  def install
    if OS.linux?
      resource("gperf").stage do
        system "./configure", *std_configure_args(prefix: buildpath/"gperf")
        system "make", "install"
        ENV.prepend_path "PATH", buildpath/"gperf/bin"
      end
    end

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
    sleep 30 if OS.mac? && Hardware::CPU.intel?
    system "curl", "-v", "http://localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end
