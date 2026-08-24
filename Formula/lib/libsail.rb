class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://sail.software"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "fceb5691680ef19cdf46c21e01f34fec1ff68dcc8c7061b32d66c574746a0b7c"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "2a754b3a41100520a319878d6dad5e37266d7f492c83e0e5e20aa74717ea949d"
    sha256 arm64_sequoia: "301596aab8c6b94bd327d38081b6ed9a410daf26f433247d0a73abc7e2fe8195"
    sha256 arm64_sonoma:  "de42a899326cfda7434d9d4c7361e88cc4675f7ea4573a541fe52752692a3114"
    sha256 sonoma:        "b7e30301d07d5e2add65ed3acac04b220b0dffbc9014c1825807d648d3d00461"
    sha256 arm64_linux:   "04551907c4bab39105aec7ab5cb99d671a4a2dcd690efbb501ca2fa4f22f05a2"
    sha256 x86_64_linux:  "426bd86c9904257c2ffdfee44b6e1cfb0dce7f6e449b6464079c359ac651eb41"
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
