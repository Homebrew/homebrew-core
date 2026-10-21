class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://sail.software"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "bf2905717c06b4ff4269dec010339a85994be9cc524fa3dcde3734b4df376089"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "d96d61570d4526332936b81290e8fc878acb54c7c867df01f5f5646a21181174"
    sha256 arm64_tahoe:       "3b91a115670d4cc6574fe642342dfcee1b70ef69104a93a86129ed5d54b17d93"
    sha256 arm64_sequoia:     "f23bb14fa37b29695cd953eeb1e657880a9ea494974f75b6067b47d0198b9174"
    sha256 arm64_linux:       "8345d4937bd9c5f5921c67dea2694758692fd5bda4fd05b68ca9a8d5137b7f59"
    sha256 x86_64_linux:      "5761de7ed9b9c107b00b0a40614df03cf9c47b92e8941850590a4f251850186b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg" # for `libavutil`
  depends_on "giflib"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "resvg"
  depends_on "webp"

  on_macos do
    depends_on "brotli"
    depends_on "highway"
    depends_on "little-cms2"
    depends_on "xz"
  end

  deny_network_access!

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: lib/"sail/codecs")}
      -DSAIL_BUILD_EXAMPLES=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # To prevent conflicts with 'sail' formula
    mv "#{bin}/sail", "#{bin}/sail-imaging"
  end

  test do
    system bin/"sail-imaging", "decode", test_fixtures("test.png")

    (testpath/"test.c").write <<~C
      #include <sail/sail.h>

      int main(int argc, char **argv)
      {
          struct sail_image *image;
          SAIL_TRY_OR_EXECUTE(sail_load_from_file(argv[1], &image),
                                /* on error */ return 1);
          sail_destroy_image(image);

          return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}/sail", "-L#{lib}", "-lsail", "-lsail-common"
    system "./test", test_fixtures("test.jpg")
  end
end
