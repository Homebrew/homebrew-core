class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "6cf32fcfc615542b9ba35e021635c8ab9fd3d328fd99d5bf04b7eebc80f1fae2"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ff4b9e620ac8c3868a02992900d258da285e5c65e4714e4173eadf1d41eb943c"
    sha256 cellar: :any,                 arm64_sonoma:   "5d440c0387d36f545f09143f59023708b4ec96da4ea84de9c0dfff352248c502"
    sha256 cellar: :any,                 arm64_ventura:  "b9b8358baf3faefaafe868ad7a59ddb74cc91fc01c066a50b6a8041dc9a2bd2d"
    sha256 cellar: :any,                 arm64_monterey: "e98864e2ef2539f9f5bec107060bf634ba477500a38dfb0212b2f52334a18014"
    sha256 cellar: :any,                 sonoma:         "6f74b99625f4f2fc0be7d03e1c9151fe85f5ba49b66e9bdf61fbc19fba663d02"
    sha256 cellar: :any,                 ventura:        "1d7569f624fb6d64eabbaaa51fa1295765b4e35a976664f76428af30a182c154"
    sha256 cellar: :any,                 monterey:       "28fa7e8e970f9ea616003ca89415c831a6e0b38d5d312883ea0995370aeb9ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bdf2ec943b72f4e357a7f339265a5adea7802101835796a17ec8429ee0d28f9"
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
