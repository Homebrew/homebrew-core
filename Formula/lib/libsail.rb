class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://sail.software"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "ad61a99895521d97e3215b3cec4fe8e929369225fcd5aa91f4bc26b1d85d8234"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "9c3f9a6de8485a2b996bf1b6d8abd1b9423e6192b0abee69fb2b9b2e9b50fe82"
    sha256 arm64_sequoia: "fd1cc4ac43c2b2bcaf740ad43546fa79e6ef13dff073c37a0599d72bcfe0fe89"
    sha256 arm64_sonoma:  "82cdeafb601373fd642b56be76657d448d374e7460d9e829f94d0a3f920e5a87"
    sha256 sonoma:        "099212b916e268e532561034490bd74de91ecc6b772a59d572d88608cb42e528"
    sha256 arm64_linux:   "80f51fc88ace6e6f39138a5d7be7ab21c0e7dd423116ad483dd3343b68b2879a"
    sha256 x86_64_linux:  "05686961baffb6322733daadde513dea84a4de4a6a5fe1ad9791bd6c563c8057"
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
