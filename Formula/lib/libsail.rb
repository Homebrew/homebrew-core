class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://sail.software"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "bf2905717c06b4ff4269dec010339a85994be9cc524fa3dcde3734b4df376089"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_golden_gate: "b6c0379133ed0777a036a396ac8943e4356be192d605423cdc42a55daa5e4854"
    sha256 arm64_tahoe:       "ca6e628223807e265f5c2db8f42936b0e27b72d120cd7b09a8e1de41965d6588"
    sha256 arm64_sequoia:     "2bef5c187f9d81948cc2ffb9603dec48be725d08657fcf75780f27f776556142"
    sha256 arm64_linux:       "528555c125fc4bdd971fcb580df238e96d4b0c156c0e45330722437df509be94"
    sha256 x86_64_linux:      "532ddb04c8c26ec5a1b64cf61a9000fa5f5753a7e09f5302bc6aedaa39ba32d4"
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
