class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "0a545e953cc049bf5bcf4ee467306a2f113a75110edf59e61248873101cd26c1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "79ac7837d5f965f0df486a3551aa4efbc0472f9a8a4c89f4748f6c423044c51e"
    sha256 cellar: :any,                 arm64_sonoma:  "3d278f7e6324456dcf4e25f596e6f3063078e3b77ec0a6f709aecc985f7ad7b2"
    sha256 cellar: :any,                 arm64_ventura: "8c9b7da2440de5d6ef334c1ec5345436a7206d9594ff3c7e242b66bd3fbadafe"
    sha256 cellar: :any,                 sonoma:        "7f0fbb053b843800ebf5edc64a14d5bfd4fc4c38f63e0c9c23aa1df0e5502d1f"
    sha256 cellar: :any,                 ventura:       "e1b76ac7c6960e689f40202c9ef2519a557414ae4ac577b94ddf0ad217a9b7ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77dcc8b63ad0eaa65bc4c710b88734228cb0d4884722f60200d10998c4c394f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e238743363e2d2706f9cb5671d01bb89a8ce19832f95842b228f786ab156bd67"
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
