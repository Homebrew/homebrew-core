class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "d6607d654adc40a392da83daa72a4ff802cd750c045a68131c9305639c10fc5c"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "eaa0dde55d697b8839bdf9aef55cbcf95149a33d573eb9b6b86fd5eb763a39a7"
    sha256 cellar: :any,                 big_sur:       "1362b18e8d3ebb22b44ed1527e848376cfa57c27a19707bd69871e92a4bdccf0"
    sha256 cellar: :any,                 catalina:      "81100a4fd5be5d5ac08d63bf787337e967f1d419fface9563edebec6c5ab3229"
    sha256 cellar: :any,                 mojave:        "0b1f0404f1c3c787b4db1243884991fb4c42d8f9a040cf0ee1348c3f7af9e119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bc07dec2dc59a97cab7272b0b9a406c36f3be030e8b6ffb112f9b599eabbcab"
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
