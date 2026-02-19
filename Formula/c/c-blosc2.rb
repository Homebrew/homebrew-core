class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "125e0ac2fac3d81239c1de036cb335bc8eca86b19216e97e0b23de3283d3274b"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "97f03d22c09efccd0e864ca1d5fd1615be68b68dc5c62f5e76c15108a761c8fe"
    sha256 cellar: :any,                 arm64_sequoia: "fad27821e1d3d87a8a62bb20e6d565f673783b48cb7946683efa2a0da0be1287"
    sha256 cellar: :any,                 arm64_sonoma:  "59f2c3ecc19289407699ac89d278d187782c695d246e41a0b963c4701f50ddf0"
    sha256 cellar: :any,                 sonoma:        "e97bb6a6b56aa107a7cd41cc36af69a03b4fc1221a368f49909ef9e0c87c970c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e17d9c09d63740371057fa101e016072ba3d725cfd4aa710e17935491c9fb24d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d8e277d6c6a39911372705664fb5573af39251fdc0c43b1ed8722b2e9e9ae00"
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
    rm_r("internal-complibs")

    args = %w[
      -DBUILD_TESTS=OFF
      -DBUILD_FUZZERS=OFF
      -DBUILD_BENCHMARKS=OFF
      -DBUILD_EXAMPLES=OFF
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
