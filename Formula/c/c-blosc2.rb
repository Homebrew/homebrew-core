class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "82c5d37ec947ef6616b542960cbebcf7adec709ab145d98aa306537f82259cbc"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    manifest_sha256 "556847073a38a7ad27cf50794df6ca103c3d4df7bae0fb06fe53aaf9de61b6a0"
    sha256 cellar: :any, arm64_golden_gate: "ed66955c1c613a3e59aad0f60142477a3c0c116eada1ffd0c5d5836ef07a0165"
    sha256 cellar: :any, arm64_tahoe:       "2273f5e979aee4acc690fb6eade8368b801443029303d296de8b53cf9c30a6e7"
    sha256 cellar: :any, arm64_sequoia:     "a4c33bf12cbcae43ab4fcd45d0ad97db7d00085e2bc4b94cff978743bfb4f58c"
    sha256 cellar: :any, arm64_linux:       "50f98130597aa0727284a444b0785a73e259825b535f7ae91f407aa8ffa0d08b"
    sha256 cellar: :any, x86_64_linux:      "8122f8ff5dc21abc25c4d55d008a0cfb3162e8d2e7c34aee993734adff9b61e5"
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
