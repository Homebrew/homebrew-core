class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2025.08.11.00/proxygen-v2025.08.11.00.tar.gz"
  sha256 "adcb875fda718aa62fe47dc9b25c45c65632ccec583452f302624619a164e44f"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "5fb5e493c5e1e64d7b1fc12b504199bdf027d7d72f68b929e55d15fbfadd9641"
    sha256                               arm64_sonoma:  "77a6b12d20588ee4a7d2ef7ce2d61c0da428050687da6c56167c123849bcd068"
    sha256                               arm64_ventura: "20705ed1a16bd3ec3255380fae5fe7c3bb505375ec09062cad09e252f95d2a5c"
    sha256 cellar: :any,                 sonoma:        "ebe8b1113d6955a94a86809e5dd689ea0f08deae8bb213086f47d22ff452cefb"
    sha256 cellar: :any,                 ventura:       "f05c5696db73009b2f6df1d0a598116cfd8065fc5186ec9674371d841602f402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27722f73381b6f2d64a78f800ed96a47e7abd8cf7cf74cc86bfc573250782087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f5575911ec786dbd86c92cb6b03e141927025a2ce5cf86b42ba9482cdee0395"
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
      url "https://ftpmirror.gnu.org/gnu/gperf/gperf-3.1.tar.gz"
      mirror "https://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz"
      sha256 "588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2"
    end
  end

  # Fix build with Boost 1.89.0, pr ref: https://github.com/facebook/proxygen/pull/570
  patch do
    url "https://github.com/facebook/proxygen/commit/d69f521bc0c7201ced9326aabe7ba0ca590621bf.patch?full_index=1"
    sha256 "2b51cbce006750d70e6807bb186d4b06f9ec1c40f7109d0f0b8a8910581a39a3"
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
