class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "6c6fe90babfa09bd3c544643d3fc3ea9516f9cbc74e8b3342f0d50416862b76f"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f820ecf050dde9ef617bb1e28c8d1b9987fa57722c0bdc154d93bf348290d79"
    sha256 cellar: :any,                 arm64_sequoia: "fa614d11fe7e227f90eb31cd5451922d7e8caefeb1a34e0f9b58881273307423"
    sha256 cellar: :any,                 arm64_sonoma:  "9e34d9da95cd23a613df03316dc2265d1b6bd3760c1ffea05557eb7472654c0b"
    sha256 cellar: :any,                 sonoma:        "c0c9c46deb7bc4445ac4df610ebb3149a3444f68a6760f3ed9c32742d7a46c62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6908c36b43da80162fabab4cd7221ae27a5e6b2f1ce983d85047d1d36ec19b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f62a8ef1b11574dc12b785c90f0c358dc0fd0cc116d040d102d2d5720e82f2a8"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

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
