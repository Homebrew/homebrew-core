class AklompBase64 < Formula
  desc "Fast Base64 stream encoder/decoder in C99, with SIMD acceleration"
  homepage "https://github.com/aklomp/base64"
  url "https://github.com/aklomp/base64/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "74f83a5396660dfe5a09f0339982c03c44ef018e459a8bfcde8b31ca7444aa42"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fb7897d5b01015c1c822eb377386e05e86aa88e3245b4985b2bb8296b5fcb271"
    sha256 cellar: :any, arm64_tahoe:       "e8e07afc04ee9eff70174ff6fd2e81c805974b13c4eedb39084ff64d87c1eb10"
    sha256 cellar: :any, arm64_sequoia:     "adce7d96d07a299cb3709876646c4c440bae5e166ea839c2868b97f74d61b514"
    sha256 cellar: :any, arm64_linux:       "8229597aebc6724dcf70356b58a7773b8f28ab4cd86d6e2428f0902d0de7c652"
    sha256 cellar: :any, x86_64_linux:      "9ea23400ac7c9a9559c269efae189bc9c16a846bfe05f03865ef85e42adb2b2a"
  end

  depends_on "cmake" => :build

  conflicts_with "base64", because: "both install `base64` binaries"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "aGVsbG8=", pipe_output(bin/"base64", "hello", 0).strip
  end
end
