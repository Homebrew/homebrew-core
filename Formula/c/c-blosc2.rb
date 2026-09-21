class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.3.4.tar.gz"
  sha256 "db6ba3ee4f863a3c15794fbba99a4e5704d6a01017799628546152c8f4b06818"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "3850c2d7ee303d60d2b86e9df8f48183a5d5f96af5e6b20c8bc1fa1d8fa92235"
    sha256 cellar: :any, arm64_tahoe:       "2c571c64c9156dedc19acc3809c2a082b89eab1cfe324dc6d9b56add0fe3fbac"
    sha256 cellar: :any, arm64_sequoia:     "0cb9a1b11588983b2dfe882aa41368346f3350556608abecf9cb9ab33455dd70"
    sha256 cellar: :any, arm64_linux:       "8d03dacfab93068f887b0ccd6c699d0755c756d36378b14acfec14fdeb24d2c4"
    sha256 cellar: :any, x86_64_linux:      "a523cfb2752132bc500546a8dafeaa81de799ecd90379a61fc114b9789d2ef51"
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
