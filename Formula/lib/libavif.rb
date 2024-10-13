class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "914662e16245e062ed73f90112fbb4548241300843a7772d8d441bb6859de45b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5641b53ec822784a00609ffb9c9ea9c38cc29c1a3838279dacd0b6572f296a2c"
    sha256 cellar: :any,                 arm64_sonoma:   "d933afea7d7bce60d38fc1458049972f95f27ce057ea4d8b850dc1cd6dcb6de2"
    sha256 cellar: :any,                 arm64_ventura:  "7a4eaeb370ff41768a9ba47950903fd55b26a483236bf22f6cdd51ea00bb02f4"
    sha256 cellar: :any,                 arm64_monterey: "5d3979f1377fb7b749d7447ab90d018a454df227bbfe58e2d9f56e42f4fcd4b4"
    sha256 cellar: :any,                 sonoma:         "540f311fe23279f796ecdbe153b9f8c0d167d83103420c0ba84a574d4b59dae2"
    sha256 cellar: :any,                 ventura:        "4e251329d5c5a9063db68af15f49c06bc66300593b02badc4f1eeac23940ea5f"
    sha256 cellar: :any,                 monterey:       "f7a30236240e855c0fd3925306cb5cc779f405925698146504805be441b34c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b20f6d93e81077c5bfc56392436faafdfd25f6fb5934c88f4fcb5f56e4e79b0d"
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
