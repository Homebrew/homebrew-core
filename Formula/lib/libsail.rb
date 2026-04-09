class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "dc0d6fa87cb4fa8b514f450a3fb13cee6e3e60f03250f683564fabbec0f722e3"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "f9430ef88d447e7f1d33199e1669076af4a092de4122b1dbcfa07addf3c5ecfb"
    sha256 arm64_sequoia: "ae62b694076e458585bc69386bcc005eafd5ef51fdfea4ee12976c85da3f5624"
    sha256 arm64_sonoma:  "333235f4a7f21d3297d807b11053f2185b02959508ea4e7d80bdf2f2ad3d95b8"
    sha256 sonoma:        "e09065341ed58f92a8f7ca3b9877fa173e6d27680484573c2ee88fbbd507d6ff"
    sha256 arm64_linux:   "0147ee45b7482d1b0b8dbbda068878427ac491781ad89917ddb5f76d257b2726"
    sha256 x86_64_linux:  "2c02036e2ff8515835ee3a530f26681c22edcc2e55d377bd8168ac4d9d62e65f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
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
  end

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

    flags = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs sail").strip.split

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", test_fixtures("test.jpg")
  end
end
