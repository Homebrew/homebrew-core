class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://sail.software"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "ad61a99895521d97e3215b3cec4fe8e929369225fcd5aa91f4bc26b1d85d8234"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "6a61f62b49d1433bf863fa01156b3083273b7a503ae0907aac5eaf31b9feb6d6"
    sha256 arm64_sequoia: "e69b7ebd2e508a38cde99ce96755a4248bbff83420f4a35a9dc948ce361b530a"
    sha256 arm64_sonoma:  "0604d6407b5042756f45a20c6f848d4ae843122176ab502c07e0be0dcd09ff7a"
    sha256 sonoma:        "5252692b1a3e03d1887e5d5bdd887bb539285d6decd4a25232fd11e8a0402a0d"
    sha256 arm64_linux:   "a6979c3a9aa83ce90f3ac5cf821bd190073ba2bb5e72c2c64afe13b340f3851f"
    sha256 x86_64_linux:  "95b36ed1ad4bab9b3fb2215e314b939f034cccdaccd5656c2100d291b7de3a2d"
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
