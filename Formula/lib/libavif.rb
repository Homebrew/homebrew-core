class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "398fe7039ce35db80fe7da8d116035924f2c02ea4a4aa9f4903df6699287599c"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "aa693b58c72506486ef50575cc41622694f3defbfc0f22cfe70beb6440fd95e2"
    sha256 cellar: :any,                 arm64_monterey: "d9365bd3d2af26a58a0b97bd38950f4a3552e2db636e94fe979adc4afe862bb5"
    sha256 cellar: :any,                 arm64_big_sur:  "3d5d27c66520861b3617a5bbeec94fce564c00b7372f5442003b782202b8b51d"
    sha256 cellar: :any,                 ventura:        "ddcc5741e21a55901035eac578f559d7082fd16ff9e38c0f3071feb448d928e6"
    sha256 cellar: :any,                 monterey:       "0f2f58c588305b6e29d99b9e789c59a1c72dfb9f34936f6ecefea7db605db4c3"
    sha256 cellar: :any,                 big_sur:        "cf9e39eadf86c47bac043ea4ce305bd934384ad466ecc862385c7c81b0a3ccd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0306509252db9ce7dedb1801697e4a65f7e8340c668b9c36d8e0ec1f8d17ca1"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DAVIF_CODEC_AOM=ON",
                    "-DAVIF_BUILD_APPS=ON",
                    "-DAVIF_BUILD_EXAMPLES=OFF",
                    "-DAVIF_BUILD_TESTS=OFF",
                    *std_cmake_args
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
