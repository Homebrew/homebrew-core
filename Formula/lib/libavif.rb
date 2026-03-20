class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "713e2b998ca0bf5473fe4624afdbc7fa9f6e4799dd414020fe67d56f6997bf4e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c56406e359dde4df0875ff0a4436d8e86b85cc98c6210c2348c9b2283be1f9d"
    sha256 cellar: :any,                 arm64_sequoia: "e98f3ffa71916de475d6684f10099613836a2aa8fd1940c85a3a8aefef9c0b50"
    sha256 cellar: :any,                 arm64_sonoma:  "957d39eb29ccafd6809b8cd443889d3e262431807b15b4132c7be7b854e48b1f"
    sha256 cellar: :any,                 sonoma:        "b2fd0142c91bec58b5fe63a2b026de94662483ac6684c5798f34c9e156c19ed3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d97e73d516ef3802aced612e98fd3c853cbba5f0aae22ed52c71e2626e138c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e6b10839fd213f70c6c64f1e9458a0b0e530455c8e053de2966d1f938f213a1"
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
