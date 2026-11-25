class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/meta/proxygen"
  url "https://github.com/meta/proxygen/releases/download/v2026.11.23.00/proxygen-v2026.11.23.00.tar.gz"
  sha256 "15c877c472165a43801af4f35a145be28105adc577b7a908545b061e1baf760f"
  license "BSD-3-Clause"
  head "https://github.com/meta/proxygen.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "29ecca332861e0890ee50b2a0c59ec4bfc686cdb84a90a49fe696bb6b9ac0000"
    sha256 cellar: :any, arm64_golden_gate: "a5ccb836ad85b3a81866eb1338228e262566db3321ba91e9cc356314cdafe4ac"
    sha256 cellar: :any, arm64_tahoe:       "2e120d61b9972af1e8239940edfb2c3baed65c088ba2dd93c24908c216d77edd"
    sha256 cellar: :any, arm64_sequoia:     "b8aa2dffe25b789e3d9f4eabac9f9d4a0172448d85862962f3c9ef6313fbaf7c"
    sha256 cellar: :any, arm64_linux:       "458af2972c72d992da06ac3e565e58fa4fe9f04021e76911b15225c5ca95254c"
    sha256 cellar: :any, x86_64_linux:      "f898faf341015fcbc6d3ebe3a9342e5fd549c3b36886581e3676f9c136239a62"
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

  allow_network_access! :test

  def install
    # FIXME: shared libraries are currently broken
    # Issue ref: https://github.com/meta/proxygen/issues/599
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
