class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "c68b290ac98361941da88d6581ac276689a06e08b6da5e90bc8403a9b088b092"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7a1c2df66e29839d5320cf0ebdfbdbb24a020da48e4bbed838727cbd20954baa"
    sha256 cellar: :any, arm64_tahoe:       "2b136d53a9b26eefa45a11dd49a09c32f25549931387f2734611e554798f0f28"
    sha256 cellar: :any, arm64_sequoia:     "3cee7d5736eff9fa858dac41e7317a4e1fd475af7402ce979a5f5e4cc35fdde3"
    sha256 cellar: :any, arm64_linux:       "e45e215bb8bcb90aff58f5fa8743fc9da8ba026368518a203170efdb453598a8"
    sha256 cellar: :any, x86_64_linux:      "9bd152b5d770fe7cd8d0fe58904fba22ad4ea915d1b0a377a32dd93219218ad3"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "zstd"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1400
  end

  deny_network_access!

  def install
    args = %w[
      -DBUILD_TESTS=OFF
      -DBUILD_FUZZERS=OFF
      -DBUILD_BENCHMARKS=OFF
      -DBUILD_EXAMPLES=OFF
      -DBLOSC_DEPENDENCY_MODE=EXTERNAL
      -DBLOSC_ENABLE_ZFP=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/simple.c"
  end

  test do
    system ENV.cc, pkgshare/"simple.c", "-I#{include}", "-L#{lib}", "-lblosc2", "-o", "test"
    assert_match "Successful roundtrip!", shell_output(testpath/"test")
  end
end
