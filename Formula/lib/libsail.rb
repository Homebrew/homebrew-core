class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "a882f8a88ad1fe3e833abe44fd2120463b4ab27f0b00ed8547c8a9616cc548f1"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "72d83230b9abf562bd455e14391fbfc10139718611796e715e429f13402fd1f7"
    sha256 arm64_sonoma:  "84f8b9225541b6e925166e4785c9620ef42176ea314b8f5919d7675f4fc3e56b"
    sha256 arm64_ventura: "ca2b55577c819dbb4574adbe28f09f79d1336696f485491a497b5c2a6c9fa510"
    sha256 sonoma:        "741b81430d6192c2b0d09a2e8dceb437ed8a2294ad6e55ce3e4ab594be67a10f"
    sha256 ventura:       "6d9e3f76154771759bab029c121f94bd467e247fffb065ba69d5ac74768890bf"
    sha256 x86_64_linux:  "17994b249055bd8d8509d9f484a12f42738df1c033b2841ebfa972a1cf6c797d"
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
