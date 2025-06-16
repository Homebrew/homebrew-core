class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2025.06.16.00/proxygen-v2025.06.16.00.tar.gz"
  sha256 "67b76af3eb0c4f17dd5b218ff81ffb089721d2650e53391b319cf93701572e05"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "16b56d9895d67f7baf707458fe3bd4295912cf24d1ae87720b8b52d9d5598a49"
    sha256                               arm64_sonoma:  "84c0157a32e0a91f9589d3b1d9422e80c85f4058c83942d3787628c93a354e17"
    sha256                               arm64_ventura: "6691e063863bf96db08daba549a3f270f7b28aad822dcb8475a3ed8d53c74ef8"
    sha256 cellar: :any,                 sonoma:        "ccc5d71b5c43924f6e6febdf5cf99f5a57a3b1c7ca3c9c0c3ce2acfc72b82575"
    sha256 cellar: :any,                 ventura:       "de05145008bf2a7d8984855d61da87ed0055a49a2e1563a1ca2a3d2b1ccd1bea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39321c6b70717ede99f79240d1d89cc0fe91ba86f711f60056bbbc4ce3cabd0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9551413fc478c9ce747fb3d89906c8f786cf48a020fd9cba3f562c139782c0cd"
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
