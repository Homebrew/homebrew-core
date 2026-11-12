class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "be617e6809ae569dcfb2ffa0ea56b3b92c8f669da0c97542c031412ce7f3e831"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0c28b60818efdb4430bfead2d9b8f48b64fdee71fda0ed0cb8c08d2b8bcf41c1"
    sha256 cellar: :any, arm64_tahoe:       "20c781b2d87bdecfecff2c01b952eb0e68ee32888e9e230cb683737b07e27223"
    sha256 cellar: :any, arm64_sequoia:     "c76bf1b42b4e21947554b5941cd6c118d2a83def2b0016ea68d7d3ff25011ecd"
    sha256 cellar: :any, arm64_linux:       "d1fee9947fcbda9352e6e0e7a20dd6c89e1167d0e721f3346a20b880ca86f38e"
    sha256 cellar: :any, x86_64_linux:      "9eac108c42c53d0339e4400c0f8435913b7e39a3e4f850759399f15c0c96c011"
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
