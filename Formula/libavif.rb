class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "bcd9a1f57f982a9615eb7e2faf87236dc88eb1d0c886f3471c7440ead605060d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "795e345bdb87f084d5bfaa3e7b3f59427f616edd5dc813f2390036961f5d4297"
    sha256 cellar: :any,                 big_sur:       "bcd23dbcfc953ce8316e0136bcfdb56aeb14345afee0fcdf2e106437f2e0dbc0"
    sha256 cellar: :any,                 catalina:      "474c33552de4bd16b6331ee8d97314877eaa3d84f897983977690cb9f22d834a"
    sha256 cellar: :any,                 mojave:        "a04c9ee0e1d0e9435e4118ffb837c179244f15b355fbb0480384973dab90fa23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a405b91c6123f9a11bfedc685fb19db3fa7b607ff5bf2078c93ca64c3c69f34a"
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
