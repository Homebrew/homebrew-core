class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "d4aea31a4becb3273ba7968221be2e48148ba05eb8a68d14e671963e17785648"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44d57589d5dcaedb19f883c8e4e1d328c9041494d0380c60d97272854a13f749"
    sha256 cellar: :any,                 arm64_sequoia: "697f6dfd4acd6e06053a7ad50378e80889199b0ccf834d0a1578a497a0cf0aff"
    sha256 cellar: :any,                 arm64_sonoma:  "cd850b316534c631ba07b625d33eed0d4d5c6001d73bb5783055be1ac2376ebb"
    sha256 cellar: :any,                 sonoma:        "12d4cc2b73516496876a3e93f821858bad28e47a76fadd3b15c7dcefdc495734"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6806097bffeb1f1635b3545c8e35c24eecf9a7d89ab7a04b6ff7620f65e1e8c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8631446bdda8ac7f2dfe1142369d91b9d09b317806c2d15263adad5ef67b4ae5"
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

  resource "libargparse" do
    url "https://github.com/kmurray/libargparse/archive/ee74d1b53bd680748af14e737378de57e2a0a954.tar.gz"
    sha256 "7727b0498851e5b6a6fcd734eb667a8a231897e2c86a357aec51cc0664813060"
  end

  def install
    resource("libargparse").unpack(buildpath/"ext/libargparse")

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
