class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2025.04.14.00/proxygen-v2025.04.14.00.tar.gz"
  sha256 "4ba8f199b1535899d3c9800db90ad0fc2995e9fd2c6f29e2872654d051ef5977"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "39dcac55bd4807eac801dd676b540aef86d2080852945f410330e949d2660643"
    sha256                               arm64_sonoma:  "941adda76a94cbef3baf6e3e7bf5f01056b8dfe62ea0e49a3acf551dfac65136"
    sha256                               arm64_ventura: "fc0fa530f42d86da951ea6e19750dab8a9c4c91d4825544a96d386ead87eb5e5"
    sha256 cellar: :any,                 sonoma:        "272084b86be566607bc205665b45ac90a6a61ee2096bed9a6fa8ba0f6e84a8fa"
    sha256 cellar: :any,                 ventura:       "870cd952305ab527910af5d031f728ac05bc5fa496a181a41cdf3b077a8c3b4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ba9537785b8d10a2c91e9b15fbb947520ecacc6d95f18b573fa3f70f4978183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4c6fba5b99c54f68eabb7d96f3d3290bdb9823cdffebf6001f3abcfaf011b4b"
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
