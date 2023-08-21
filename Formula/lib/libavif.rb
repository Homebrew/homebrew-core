class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "0eb49965562a0e5e5de58389650d434cff32af84c34185b6c9b7b2fccae06d4e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9b4735a70692b1e1cb060a3239bc22b2226cb663c7321474aaaa7b237772a68c"
    sha256 cellar: :any,                 arm64_monterey: "7894a74f1c218445038333053255a70edd4e5bbd7db601df3f9544c53c19b5e6"
    sha256 cellar: :any,                 arm64_big_sur:  "89dae84c1c6432e7fce025d72236606fe3cad655b596a19638754e593d608092"
    sha256 cellar: :any,                 ventura:        "920c5bcf0ebdcd67b5c8fb124b3be365d81fef5b44aaa9e82f0d487aace15a79"
    sha256 cellar: :any,                 monterey:       "62c3120e7b162a29839b38a1eb53db3f25caa15495aee7cf5c9c54b353d9c965"
    sha256 cellar: :any,                 big_sur:        "cd42d557da81863120e2a542200c5bebc56b0fec042758157b7c2dec6ac557c7"
    sha256 cellar: :any,                 catalina:       "b7d1c39830e03db3700c701faad8f9df4ea9ac61f52034a49777b0fbd998474c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b519a99be7b7bf73c940eb53f1bd89cb8d06317f4888e6d71c217b03242e15a7"
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
