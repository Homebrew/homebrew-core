class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "d02ce889b70d9e237b64806df26b044753e3edf3e87c8af42c32ec9968133a88"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "892e810cfbf5c82f3669df92557b09f5e1a95ba05e2fd8bfebe122739048138b"
    sha256 arm64_ventura:  "f12a4b9944c894afe54f83346af3f2df20354ce7399d163b104a99633ee5c26c"
    sha256 arm64_monterey: "fd19a8ee959db32f42c8d7cd669fda6de6ba9251210f7a7c6ee0075872b78ea2"
    sha256 sonoma:         "9bd6302b283f72605c3bbd49a37200e04e65e1fb01e73845248a79fd97b6115b"
    sha256 ventura:        "2397b138d40673b3496421e5eb291f4e7ed2b111e1e728d4f6a9e876fc2ed6fd"
    sha256 monterey:       "878495a910f5b5b637c31ac2f796c49798509ec1ee0964ff82149064b07d82fc"
    sha256 x86_64_linux:   "beeb7791e76ad1e875ee941e9a52777d65f3a9b4d3d580c9970f8c05540b63f5"
  end

  depends_on "cmake"      => :build
  depends_on "pkg-config" => [:build, :test]

  depends_on "giflib"
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
    system "#{bin}/sail-imaging", "decode", test_fixtures("test.png")

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
