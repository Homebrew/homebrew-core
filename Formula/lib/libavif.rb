class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "9c859c7c12ccb0f407511bfe303e6a7247f5f6738f54852662c6df8048daddf4"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c44c28b7141328d5a3eca015fa7ac4fc13ecf42f137405358f658646264c766"
    sha256 cellar: :any,                 arm64_sonoma:  "c82c77f895818aab922235f77fceaf50f2ef974dfe126297685c2457d6f73e3f"
    sha256 cellar: :any,                 arm64_ventura: "ac77cb3a2d3454bdb65849f62eb012d462c36e2c99e9ce4cb5943ac995ece7f7"
    sha256 cellar: :any,                 sonoma:        "017c5e8e2fd2c29e85a549292d4df072b7e25bb22553538d9fde27f9f458ca7f"
    sha256 cellar: :any,                 ventura:       "29c4fe070f05b1fd6f67fb9987001a570c736fa39ceefe7dfa7fa92c7136612e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f475b33e6a5e14decaccea79d41fbd0b8c827c7d8478f162e9ec7060caf1a0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8513ff0924eec754250e1ea79370950fbb6be068a7a155583b58b5ad1ac34f60"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DAVIF_CODEC_AOM=SYSTEM
      -DAVIF_BUILD_APPS=ON
      -DAVIF_BUILD_EXAMPLES=OFF
      -DAVIF_BUILD_TESTS=OFF
      -DAVIF_LIBYUV=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    system bin/"avifenc", test_fixtures("test.png"), testpath/"test.avif"
    assert_path_exists testpath/"test.avif"

    system bin/"avifdec", testpath/"test.avif", testpath/"test.jpg"
    assert_path_exists testpath/"test.jpg"

    example = pkgshare/"examples/avif_example_decode_file.c"
    system ENV.cc, example, "-I#{include}", "-L#{lib}", "-lavif", "-o", "avif_example_decode_file"
    output = shell_output("#{testpath}/avif_example_decode_file #{testpath}/test.avif")
    assert_match "Parsed AVIF: 8x8", output
  end
end
