class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "53c6ed1167683502f5db69d212106e782180548ca5495745eb580e796b7f7505"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "58beb2b79bb984d4e73c71b84614cfbba11e85c68575202d5b3a5cc81d8f5221"
    sha256 cellar: :any,                 arm64_sonoma:  "b5f40feddf8a2f2e39825db956b8cf1974d884ffdde312b7e7afae86a69bcfa4"
    sha256 cellar: :any,                 arm64_ventura: "5feb28dd5e0f6d0aa40d616b8658e3978bb5da8b4bf381d62b1b3c03f72f5e4d"
    sha256 cellar: :any,                 sonoma:        "797bb0441a67fa5d52ba8cc46eee6f14a2b87acda45fd0e52f0cd2fa1cf7d68f"
    sha256 cellar: :any,                 ventura:       "503723663a9800963f7a0b3521dd05014771d84945b79d9395a368d7e2762264"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23d52dea4d4b15f3daeee5f2f7099734e151700531831e2cd13e03200ceb0180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d252ebf05d445af884824d32ab6c6622588c1c200bd3d3aa9285f9579bf5436"
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
