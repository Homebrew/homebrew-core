class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "2b645287340ba5a631d268b551dc2d72bd73ac33335962dd36dcdb6d8366921d"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "584d41a9ad0fd601fac27735b928483c3f8494d4e08d6461599f7fabc915783b"
    sha256 cellar: :any,                 arm64_sequoia: "0d1a9ce6320d9ddacb3e7ca31bb2ef3216529755ab1df24eac833fec27b25c95"
    sha256 cellar: :any,                 arm64_sonoma:  "0c6314fd072001e7cb03d1cc065d7934dcf25edca3e8d413008ca268f1429582"
    sha256 cellar: :any,                 sonoma:        "5ebfe4ae085f4dd3e13a6c833b104939ac11d6abc28ea7a2413f471548444e68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99cf708f4f061f25e916e4212cd9ba2159daa5a498689f94b25995edbe7f734f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "824125e726a4ea8c4495ef60d538ef5b769037bd9c4acc7c5a757d0cd03c4819"
  end

  depends_on "cmake" => :build
  depends_on "aom"
  depends_on "dav1d"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "libargparse" do
    url "https://github.com/kmurray/libargparse/archive/ee74d1b53bd680748af14e737378de57e2a0a954.tar.gz"
    version "ee74d1b53bd680748af14e737378de57e2a0a954"
    sha256 "7727b0498851e5b6a6fcd734eb667a8a231897e2c86a357aec51cc0664813060"

    livecheck do
      url "https://raw.githubusercontent.com/AOMediaCodec/libavif/refs/tags/v#{LATEST_VERSION}/cmake/Modules/LocalLibargparse.cmake"
      regex(/\(AVIF_LIBARGPARSE_GIT_TAG (\h+)\)/i)
    end
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
