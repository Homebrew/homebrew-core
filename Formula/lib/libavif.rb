class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "dc56708c83a4b934a8af2b78f67f866ba2fb568605c7cf94312acf51ee57d146"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9008bf76467537b799707b9f01c1129e64619787f8c198b0ce530f3656479b4b"
    sha256 cellar: :any,                 arm64_ventura:  "977e29672df4024348ace66dd3edde30e9dae814e853495ab71952f7235709b5"
    sha256 cellar: :any,                 arm64_monterey: "318bc676dd0a6ce9909989d6de3bbe4384fa896be79836fd4732dfb6751b30d9"
    sha256 cellar: :any,                 sonoma:         "793d7b8f74e2da2cfd2cb8d962f19ef9f86166b0d94725a229306ce5c1f53bb4"
    sha256 cellar: :any,                 ventura:        "ea4a0c3cd59b1464c0386028044e4b8e14f222a0a26b8507bf462819a9f05eeb"
    sha256 cellar: :any,                 monterey:       "79bd420212737f7dcd74fbb75ed52e3ceed73dafad61b2fc1201e5ff2630c706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88c480ade965017a0f73774b2517df7579fd06dc9495db9d08f0d2b4faf2272c"
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
