class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "d289e5029cb3853630ca85716b25b5fb9cdec51f8bd537b05f43b3325b480ab0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5dfba85300a532bcfc0c2ae85bc7ce44fd6aa3fe166c03cc54ae8c11e323edb8"
    sha256 cellar: :any,                 arm64_big_sur:  "75d6af4cc4d744a64d057cdb0851e164e170ff8ededaa4d0b9077ae20de03c65"
    sha256 cellar: :any,                 monterey:       "6460e4704b6fe67068a29d6c105b928c0b02b8f81e819d5fc38c63264160acea"
    sha256 cellar: :any,                 big_sur:        "2fc619cca090838dbeecbe7cdf43c9e8555e369918f7a0230843a1a9440b14c9"
    sha256 cellar: :any,                 catalina:       "c2bce8360a9b132a470905fca32dd4333a3c1eec2bfd43cd924953122f3120aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65683ff620a4cf5bee7803e6c61282658584eee58ed30c170d3f3bc7ff0c095b"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "aom"
  depends_on "jpeg"
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DAVIF_CODEC_AOM=ON
      -DAVIF_BUILD_APPS=ON
      -DAVIF_BUILD_EXAMPLES=OFF
      -DAVIF_BUILD_TESTS=OFF
    ] + std_cmake_args

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

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
