class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.15.2.tar.gz"
  sha256 "32d0cb011303878bc5307d06625bc6e5fc28e788377873016bc52681e4e9fee9"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "448b12c38cbc4320e80e99113485b31807e244db6b1ef5c48ab3381b6fcbc46d"
    sha256 cellar: :any,                 arm64_sonoma:  "0b5c04a7f02daf82239c4fda3cc48710b7cf05db3b2eba342bb58fcdd84a7ae4"
    sha256 cellar: :any,                 arm64_ventura: "a2a210b917f6ebb7baa9ee7de0a455fbc054d59cac29ef1c15d69d7925b4b260"
    sha256 cellar: :any,                 sonoma:        "8ae1f5700568cc974952aaf9e3dd9546728034463cb6194e5152eb701d63897a"
    sha256 cellar: :any,                 ventura:       "1a0b02435b2d5d880b77caa0dc0d84f7cb758924e8d7b88c7b0c0b9b930329ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7dd1717feaf38a0f81822c52de8aab783a805d67e4ab14a7a387bdb0f0dc270"
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

    args = %w[
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
