class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "66e82854ceb84a3e542bc140a343bc90e56c68f3ecb4fff63e636c136ed9a05e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "febd8e9323eaedb8079bcad420b689cb0f2ce7d443f7aef867d6656297488e70"
    sha256 cellar: :any,                 arm64_big_sur:  "d5bc9850e31bff49542703f6a35a9f6fff240045eabe9ea2daf914b45a72d4b3"
    sha256 cellar: :any,                 monterey:       "9d9a141b3f49071c4520b499d7ca30818ad2a18ebcba63df326fa980fd46d253"
    sha256 cellar: :any,                 big_sur:        "7cd60491a115a112cfca358076359edba4c137c6a9a6c7be4cde710ac3817d71"
    sha256 cellar: :any,                 catalina:       "3b9611a1b827880d54ef0a8fdae35f911cb2df2e9372f8d15c32224c56df8d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "162daea36979f79d7aaabac8b02ac722d8799e303aae4a1d21306afda84d4279"
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
