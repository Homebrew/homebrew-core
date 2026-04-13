class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.23.1.tar.gz"
  sha256 "3a1a55d1e3794fb2b51a12e722d611b3e577443abb7ff9951666511f576ea3da"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91448eaa6c8e16b006c19886acea4ac58264283dbf3ea8fd162ff1d39e6db9f0"
    sha256 cellar: :any,                 arm64_sequoia: "0be8067bbf25c9d6b967ca40b1b00e104b6360e94dde074bfea9d9513e1708a5"
    sha256 cellar: :any,                 arm64_sonoma:  "c5389b2626af39a505b153259d9293f76b687622a920d498725e9ed1a17d6d99"
    sha256 cellar: :any,                 sonoma:        "bf86940c02cd637d88301284e74a606c4d4bffc830d53a48d711a4e744b8fbdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc07ddbf6019521e4c51d1207772f53066a4e5edc613b52e46e578bdff046d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9905447e2b2599757bebab05c143b0f94f5708d943d1e58b4520553abd1373c"
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
