class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "ba2160f0825171ab3c41cbc5bb0834bf56439d2986e5aae5f586d5e2009dd9cd"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "a041f04044e8d2688d22ada98c499b56bf7f7b88923be150179f276dcca8a8e4"
    sha256 arm64_sonoma:  "a26d7f5969d4c111616c5ea768117e5aff27dcb2cac4e03ca90f37ab536444d5"
    sha256 arm64_ventura: "621cdbbba8f478c344b7972d816ee708fe2e8e76b8167761e4a86b288b691c29"
    sha256 sonoma:        "aa473ee2d889913139dca352e019d8c2db8b266996c4bc65dc0c6d5e5294ec1c"
    sha256 ventura:       "4268a9d811d1d9381d6374b22141d85e09308fd5f319a50c22abb71286af20c0"
    sha256 arm64_linux:   "7fe21e8907150426012d1c18d08e95d83f514cd37adaf4e616b61dd678439056"
    sha256 x86_64_linux:  "0cf7e10d5a2f95984c62d12bea8cbbe921e28ffa669abc04fe8136267e61e199"
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
