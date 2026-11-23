class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "ab6dd0c838908b7da86de25a9a49ff0fa027ced131b9b2a0ffb26f3d942996f3"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    manifest_sha256 "bbd33f5a5e419516d6eb1f24b286ec38feef34b697872deaed9390b3ee545e2d"
    sha256 cellar: :any, arm64_golden_gate: "86e3d48466e832f0947a4b9d5cb9ea37e6bcd66fe53db4248e36ccf90f1751cc"
    sha256 cellar: :any, arm64_tahoe:       "7986b69bde12dd59eda5c3735f01bdfe8a9da63ca08dd9fd37b8459f7bd6280f"
    sha256 cellar: :any, arm64_sequoia:     "19de33533ec521cf90de23de161378322057e70c409d2e5579e9747810ac00b8"
    sha256 cellar: :any, arm64_linux:       "0d7821b119abce406ee292d11c0fad203419750a986f200bc2fa752a027a9a6c"
    sha256 cellar: :any, x86_64_linux:      "dc4d59d1334586b2d5a1794fe18cbbd36576f7b2b4ac90eb33773c8fce19f8df"
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
