class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.10.26.00/proxygen-v2026.10.26.00.tar.gz"
  sha256 "7ef529e479989833aa2d9dd1dcd073d3a12985d549c4a1daa1067da8234e8d64"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c22519e43daae4dcd107d50557412c4f39af219e888afc0fb2d46c3d8fe923f9"
    sha256 cellar: :any, arm64_tahoe:       "6b583b6df2a0d632ae402f8a4e3860cede7e21903ccdf7be62fd251cd66d1ed2"
    sha256 cellar: :any, arm64_sequoia:     "f3716443df5ba9f8df940d9028b3c4b6aa202134335b8217d86ed2a3af030688"
    sha256 cellar: :any, arm64_linux:       "22a04a1a66867e1086d2f5f3b46e6f4cd7aadf2a4e7cead3b49cde1965eaf23d"
    sha256 cellar: :any, x86_64_linux:      "33a44dee6f03abce35455dd79847d9b138e053df2c26012433fd5073104b2570"
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
