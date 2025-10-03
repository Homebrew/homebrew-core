class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "d9f43bbab9f557ab499c7682ebca436739a1382d39acf9cfdcf16c17feb3dae5"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "45aa2f8d92b9e266b8a9cdd8bcb2e0d54488efa3f88df61358113c8b12bf915a"
    sha256 arm64_sequoia: "35cdfd2599abb13e1a9b3a2f7321b352d02cf88a5d1d9d64cdab886b28a8a098"
    sha256 arm64_sonoma:  "6eb712c735a2202f646775be4f2ba4871ee06dd2f5ce4bbc09e2fe1cd133a4e2"
    sha256 arm64_ventura: "f670ce2263e277c6eb02acd2da60e093ea30433a410e10700a7376c607f49309"
    sha256 sonoma:        "d6cc88b1b5209563c4c1ee90ce27db20a46da3096b54a83b773374fd35e953da"
    sha256 ventura:       "03f72816f0013a2fd4439af69ec1f2198c0701d886739444c90d891393c9266f"
    sha256 arm64_linux:   "1f46ab0769633be014f3f359b8057a1e51862675056f4ac98117b3f9485d2201"
    sha256 x86_64_linux:  "546779bee8379275cc720b03f6bfdbd653abc3b32b0717bb23853c5b53222bc3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "brotli"
  depends_on "giflib"
  depends_on "highway"
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "resvg"
  depends_on "webp"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
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

    flags = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs sail").strip.split

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", test_fixtures("test.jpg")
  end
end
