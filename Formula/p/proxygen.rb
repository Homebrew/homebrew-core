class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2025.06.30.00/proxygen-v2025.06.30.00.tar.gz"
  sha256 "dcd4787f4eb7393964c7445cfbf80a2b70422946d1351fbdf6d94fd6215aef9a"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "e1db5d585542ef8748750aab71cae59d65568543b97952de8def872f7df5a2c3"
    sha256                               arm64_sonoma:  "8e8c53d6f6ad7a3783848243b3da37fe196c1da59aed7f35a377a2962247149f"
    sha256                               arm64_ventura: "daf6f14fbd91fef69b5d3743d1746597cff92a0f24bc15c328a7eb789bfe07d9"
    sha256 cellar: :any,                 sonoma:        "2a9fbe606fb7beee27aaed177f67b186a6eddc471ad44145ca6e2643ec1a194d"
    sha256 cellar: :any,                 ventura:       "53a05da68f66fc6d1f20c2180b684fd368a3ec9937c03099e3e551ba562e8ca2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e2312bfffd3657ed05a200fff7b8105af3d3be3dbe14470d25a0ff61f314ce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa2be96f7f8c230e697a81d371475cea569b8a6eb7f2acb7472282a08e6a0048"
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
