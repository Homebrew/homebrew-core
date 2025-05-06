class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2025.04.28.00/proxygen-v2025.04.28.00.tar.gz"
  sha256 "d44cd1582e42a979fdf16848b4e2ba71ea0a4163f39400e09d04c289dc5209a6"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "dd0d573410d9075ff91017da07659cd1e3c753075c95e283c38399cf8a2e0130"
    sha256                               arm64_sonoma:  "5c1177d9b2b355a91ec4d18baaaf43021b2ecf26dc7792b9b61b7645258aa2d1"
    sha256                               arm64_ventura: "677faccbc20c1fc73df06e64344de39c8f7ec50823ca652aee77c88865cfe908"
    sha256 cellar: :any,                 sonoma:        "d6d8181df7dac436153803dc29d6fdf061f6496d322ccdb41a14e305087be028"
    sha256 cellar: :any,                 ventura:       "01e7f456930ec330193e5d7a91366988269629faffcd424605399f03cee9bc7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ad65540c12ffc82c6ac3e7b4fd2296f1c0fc9863f73fc22216d42ab5a7de7cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59d45735aefa2e95c1ae979de15ac481f88c7964b45319d642550c137ab8471c"
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
