class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "bcd9a1f57f982a9615eb7e2faf87236dc88eb1d0c886f3471c7440ead605060d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "89ae2754b605c1a5dd35135ebfbf8e0d0970029fb617c8019c9566ad3da600ed"
    sha256 cellar: :any,                 arm64_big_sur:  "0e64657e9f2d5ea82d0c66aaf761cfbb7d39e245590fbdcc603743f5280313c3"
    sha256 cellar: :any,                 monterey:       "8c48b4c95b0df48df71fc8de3e924cfad0dd06c886cd9a69419a6affd7a76e7a"
    sha256 cellar: :any,                 big_sur:        "9d11f6321b3889671d683e86ebb6db03716142cdc16f0a95ce5e761ba31ab258"
    sha256 cellar: :any,                 catalina:       "f9611aacd9b0decd5ef0fbbccc67119cea5603eadfd4430ceac556f54723945e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84b065490127c11a9b8e5fe9263d270ca9751e9cb7962bb5a5ccf6ff2f3c4c08"
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
