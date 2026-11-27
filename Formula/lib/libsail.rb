class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://sail.software"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "d248055481e51807ff8e692529008042e728a6547e8e061a4247e0e55e8360f4"
  license "MIT"

  bottle do
    manifest_sha256 "d056bb6e07693829a9569c814b137121b24ff4eb8c0aa6314ac5726a802c206e"
    sha256 arm64_golden_gate: "5d9234aa13a9ae3af643f6cc3e651fe02ec40913f80bf059bb5c0108e58a1ce0"
    sha256 arm64_tahoe:       "c1811b00c767ac93d55ef94c9aa7d90b596b667a7e71071157a02805220e01ab"
    sha256 arm64_sequoia:     "7ff5ba41dd881cc9cacff7ea2031241647279369d59d12a9b958d0a3d6e4db0a"
    sha256 arm64_linux:       "caba9cf7345fa612e8ca64d4aed17af7951f37a7f8e70e0016633ae638849074"
    sha256 x86_64_linux:      "2266fe20959e65742b99d47f5e711cdccde3ed6330bbf6896016e14dca11a01a"
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
    codecs_rpath = rpath(source: lib/"sail/codecs")
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath};#{codecs_rpath}
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
