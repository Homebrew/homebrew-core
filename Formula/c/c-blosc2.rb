class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "c711e988ec25c0e05030d4db996a2e07bad3d07000c62844a4f45b2a9860a6f1"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea2d8d81b75c466eddfac8c94d00a3a56e11672cd3876110f67630cf2194f0b9"
    sha256 cellar: :any,                 arm64_sequoia: "232ebfebbf482ae94f822d7a3c7f6a96c449b3816a7bd020a49c8314c87e2b0c"
    sha256 cellar: :any,                 arm64_sonoma:  "fe3bc75c3a30e644e7cfed9aefaffa275b97fa2b97a1a39b5222d526545ed4c4"
    sha256 cellar: :any,                 sonoma:        "ff22d0e6963f1041c8184e2defee04513b651d38cc5f11165266b4673d475120"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "034c1696eca95ab0cc1db09a256379629d49132125a889ae60b3830c2031f671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ee4bd83c2e05883f731268c668f2051694ce31167bda65a9b6a79dc5808ed9"
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

  def install
    args = %w[
      -DBUILD_TESTS=OFF
      -DBUILD_FUZZERS=OFF
      -DBUILD_BENCHMARKS=OFF
      -DBUILD_EXAMPLES=OFF
      -DBUILD_PLUGINS=OFF
      -DPREFER_EXTERNAL_LZ4=ON
      -DPREFER_EXTERNAL_ZLIB=ON
      -DPREFER_EXTERNAL_ZSTD=ON
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
