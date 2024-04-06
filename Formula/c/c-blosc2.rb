class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "a45f927f6d0358d7ace24d75ef0b64df8e7d65ef2394f94d6591332fbea001b2"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "30de92d37eae898e566ba18d43d085b822303906e4e2e7007f1a414821a12504"
    sha256 cellar: :any,                 arm64_ventura:  "ac185f10981d57007ba6c5bc06fb17e9365075f594fda5fd248110a450094ec0"
    sha256 cellar: :any,                 arm64_monterey: "061069983f1a4b3af349f92e8c2b959f8067499414081ffb99d4e91cfeac7302"
    sha256 cellar: :any,                 sonoma:         "043f0378ff692843f1afd915145146ab7f815145827f030172f1fde36ef3b521"
    sha256 cellar: :any,                 ventura:        "577a4d6e2333c983dc164dd185f40ae6ac32865a4dce626a03e9bdcc085b1c6e"
    sha256 cellar: :any,                 monterey:       "d27cba9deba8573db765cfd9ebf6114d5cb366f6d8b82f747d0e37e4b7ef83d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50ca5edfadb49eca8058516dd1a14f25670466bb580428f55f1c7ae0ba233c16"
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
