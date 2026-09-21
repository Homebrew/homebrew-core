class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://sail.software"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "fe2673d76e8088084447f388b94b4639f060afec4fab4e080e493049fbb24bf2"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "cc8931d55d0d34eb3f00e9e271d0e9c6982e0416ea6b99be560a978190a7e71c"
    sha256 arm64_tahoe:       "20018ea206df90952f10fe6f7c1dfe74d511f72c96f7c121a48cc8f6f09afeda"
    sha256 arm64_sequoia:     "2f0c53bba24210b6538c230cc56cf3d572deaa7f6f1cb9ba56dfef8f9429cf9c"
    sha256 arm64_sonoma:      "bfcdd061d1396eee46c6af77f01d16ac34df92b300c286cb2940b4b0291b76e6"
    sha256 arm64_linux:       "cebe786a2b86dc33f1f59c613f5a93704d54c4fab76a1942411440a4a80e96a4"
    sha256 x86_64_linux:      "31485079381c2cf8f584f5b7bd5c4ab48aeecf20bbafb9e3452df38193074b3d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
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

    flags = shell_output("#{formula_opt_bin("pkgconf")}/pkgconf --cflags --libs sail").strip.split

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", test_fixtures("test.jpg")
  end
end
