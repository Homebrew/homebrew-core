class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.10.05.00/proxygen-v2026.10.05.00.tar.gz"
  sha256 "53315c7dfbb805baaf1f8eafc7b9830f7c7dddad29f4f4f7dd748313aa54d635"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/proxygen.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "13eb9532b6277afbf22912497f7227edb42cc72e48bc86d8183ba6f0c8aea9d3"
    sha256 cellar: :any, arm64_tahoe:       "0cb2391464676adb1b8ceb01d651e0fee283aa9eb33ef5d398a97794fea0914a"
    sha256 cellar: :any, arm64_sequoia:     "1c1ad08e9dbdf1e866ae3f2867cb4ed9c22247b0ae2922143e073cf0d89b29e3"
    sha256 cellar: :any, arm64_linux:       "acac0103cfdb45877b4fb299fe69a107ca351ceacaa18a63cd4211f2aefc595e"
    sha256 cellar: :any, x86_64_linux:      "02c98b22285c8bc5908b020e1810a96de9cf3d376fcf675a295fd1f14c096a13"
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
  depends_on "openssl@4"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "hq", because: "both install `hq` binaries"

  # Fix c-ares 1.34.8 compatibility.
  # TODO: Remove when https://github.com/facebook/proxygen/pull/650 is released.
  patch do
    url "https://github.com/facebook/proxygen/commit/61d1f695cb3b095980b0d307dc3b9bb08dc58e4b.patch?full_index=1"
    sha256 "35e427ef211b9fd1fcfe3f1a523505a1fde9eb548a434f7fc48f0650c468a671"
    type :unofficial
    resolves "https://github.com/facebook/proxygen/issues/649"
  end

  allow_network_access! :test

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
    system "curl", "-v", "http://localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end
