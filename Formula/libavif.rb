class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "0c34937f5a1f2e105734dba2fc6dc4d9b12636e17964df705d3d96c5aa52667c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "baf0787c1def41b919475ee2e959bfe3b9f67f3af03ea9063a5c536d78d5779c"
    sha256 cellar: :any,                 arm64_big_sur:  "b92b5be19960f10c45db51c724bf00fc0fef5b7e709ebc3f029a10bc4970dbdb"
    sha256 cellar: :any,                 monterey:       "3e8d5783354c79ca59d258d506366021fec36b549e0ca92cc3979b3f70a1c59e"
    sha256 cellar: :any,                 big_sur:        "84b6be93c3981a5944266690754ec5d0302e93c055d74daa08970f09c2ef0095"
    sha256 cellar: :any,                 catalina:       "776cb10e368527e351d1f115a13fe5e2e63afabaaddc12a252ac7b5fb5f03839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59d1a4f574b51fc8d27920ec48b289fe78ce1a4b7edf3a2e2726f13ef98d1f6f"
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
