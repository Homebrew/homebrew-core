class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "0a545e953cc049bf5bcf4ee467306a2f113a75110edf59e61248873101cd26c1"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfe93d3c3bae786d4756d578f7cfd290c078d9e83ca551bab704001597f007b6"
    sha256 cellar: :any,                 arm64_sequoia: "18885d98641d2a82e4afeab3c4d19d87aa367a37772cf7609615ab0b56ed0e12"
    sha256 cellar: :any,                 arm64_sonoma:  "c5f3be4aede27d832004090fbfe18144df6cf1c061836fa9f6f314ef0bc9dcf5"
    sha256 cellar: :any,                 sonoma:        "7721ab3bb40cc69b00fac770dbeffe9789a9f395ca6b1a4433f0922a5096a6f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6075a5a2124cc8f238b082022b35ad0e4b23088095fe263f3bac8109c9de2cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdbe3f050ec448e524343c4bbe29302e542fd8089ffd62d968bd860a20d9147d"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "aom"
  depends_on "dav1d"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
