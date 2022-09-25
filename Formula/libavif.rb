class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "66e82854ceb84a3e542bc140a343bc90e56c68f3ecb4fff63e636c136ed9a05e"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8a87d1f6d545e4f3b30ad302bc40d2b113fd0a5e7aef3b881f30ce67733af3a3"
    sha256 cellar: :any,                 arm64_big_sur:  "028e2fedcb137f6bc66abee05d97d9d8dde3ea05ea64c5eaacf4fb39369212ea"
    sha256 cellar: :any,                 monterey:       "e025a5a329f4cddc1f496f430b59160f50fe35a481b1926ee2b89d08960b622f"
    sha256 cellar: :any,                 big_sur:        "468a7d894bdc34acb1f51629a3629c7ad230be2dcbc4d690f2ff1d645faea2ae"
    sha256 cellar: :any,                 catalina:       "2a4b502605b778bc9ea1e4abc2637106a67f7ccce902334c9abf30650b28536f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b86d16243abde8499e2afd8fe06142c588dac845d8287aa96d10e8761f7b0bcb"
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
