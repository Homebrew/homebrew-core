class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "28c601c0399be1940710afc150b5836f8b3f5f6a35b98d7ac1467e62bc568e20"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "c86420d6da7bb3e21cdd16fbc977303fd51fce6a4c00561d0ad50384d53e0a87"
    sha256 arm64_ventura:  "97c95b8280452783a11e74baeb98e2627ff563df6e1943fe5c91817d5a176a19"
    sha256 arm64_monterey: "b44003a00fcfd9565e40cb60952cb4221a7a58c444a07f9d4affa3f09aac0fe1"
    sha256 sonoma:         "5793e722d5bd98b75e39fc436cfc508bcdd13cd21095fb8aecf97a4cbcd502d7"
    sha256 ventura:        "52208a3a89426e4400db98c74e90f9f38957cba42d4b567e35c9a208999655b7"
    sha256 monterey:       "5b81f882c0e471da4b75870ac6f14bca6e7a61f5675d936600226f9f6f8c2c7f"
    sha256 x86_64_linux:   "36e69476b19907cd6206224a1e508abcc5f8f1473499cc1794403c8366934c5e"
  end

  depends_on "cmake"      => :build
  depends_on "pkg-config" => [:build, :test]
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

    (testpath/"test.c").write <<~EOS
      #include <sail/sail.h>

      int main(int argc, char **argv)
      {
          struct sail_image *image;
          SAIL_TRY_OR_EXECUTE(sail_load_from_file(argv[1], &image),
                                /* on error */ return 1);
          sail_destroy_image(image);

          return 0;
      }
    EOS

    cflags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags sail").strip.split
    libs   = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --libs sail").strip.split

    system ENV.cc, *cflags, "test.c", "-o", "test", *libs
    system "./test", test_fixtures("test.jpg")
  end
end
