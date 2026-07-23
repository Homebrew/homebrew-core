class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "32977709c21f3fec50befa7a031fa624b963427b69d3ffb69c91aadc9279c887"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7d7bc4316c4a299cde059b4042a829964d8827d0df5c7abc9ab825895e72c74f"
    sha256 cellar: :any, arm64_sequoia: "4c46e7dcf9a534707bde523d0c9533d04b762c2d9d3f9c743baa13728256fc1c"
    sha256 cellar: :any, arm64_sonoma:  "af07c5cfc790f7458857972fb4ca9644e136de05be8bc7bdeaddc527b82cb7dd"
    sha256 cellar: :any, sonoma:        "6f948a8f66a55425e43504d3928dd2021ae6c5261cbee9a2149845bef2a1ffec"
    sha256 cellar: :any, arm64_linux:   "3e9158ad76c261d87f18dafc069160821be97758b70ad019886d0dc27943ae07"
    sha256 cellar: :any, x86_64_linux:  "585668a867a0fffbab5171fb849675628f5462834500e4d8fe9909149e74e768"
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
