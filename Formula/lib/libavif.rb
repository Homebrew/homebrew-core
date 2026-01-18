class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "0a545e953cc049bf5bcf4ee467306a2f113a75110edf59e61248873101cd26c1"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "63b4d4e52ebf66e819f6fc0c518fb22ec478e407d5f8b50b130ac16dd64ea3e0"
    sha256 cellar: :any,                 arm64_sequoia: "b054d452e2c1052cde33b729b2b683b92a69411024da1c0616eb7cd2272aa0ca"
    sha256 cellar: :any,                 arm64_sonoma:  "c8706fb82b2af538a636ae67ccf7610422ff49f57e7e55a037320fd2aef8618d"
    sha256 cellar: :any,                 sonoma:        "872e29f2f8d23d4e6835f0d255a32971ee7ff26e22030e3d104a4a53a3f5e010"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e13d2879a23634af1a5fbe4f16bd9cb5c40a6fdddfc370ab9c00e1c0e4848546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae5d0f32ff6f2b1f5c2c5f886c710c14ea2e934945c63c7089eb6cfb5efc53a4"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "aom"
  depends_on "dav1d"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DAVIF_CODEC_AOM=SYSTEM
      -DAVIF_BUILD_APPS=ON
      -DAVIF_CODEC_DAV1D=SYSTEM
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
