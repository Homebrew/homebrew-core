class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "0c34937f5a1f2e105734dba2fc6dc4d9b12636e17964df705d3d96c5aa52667c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b8440e2d462e9544a4310e32ef694f4c97ed28ca3af44b6fbc5f8bd04db770bc"
    sha256 cellar: :any,                 arm64_big_sur:  "112297416c3877025ab58c17bf5cfde07b71a630a5b43df4bc5a181c9de72c75"
    sha256 cellar: :any,                 monterey:       "863a620b8a4b17d946b8c7f44f156de5d7417cdd8a9dfa2ddc49b5b9f5db46cb"
    sha256 cellar: :any,                 big_sur:        "789a0bbd4e78b3b6337e52c8fbe95b86636f213843c887f35cd0fe86b8e072cc"
    sha256 cellar: :any,                 catalina:       "fff06b67a85499794b72f10260b0b70ffe1ce0ac74584a0bd7ee881ea9a21c66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0266601bd3a1972fc46e29fbe6d5360d053fc7fd9543635b3601c440ea2fe77f"
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
