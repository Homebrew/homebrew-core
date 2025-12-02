class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "dc0d6fa87cb4fa8b514f450a3fb13cee6e3e60f03250f683564fabbec0f722e3"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "c9a4dcaa46627b37f96ae961f8f95cf0d514c8b9f17995b8874d2f379599dbca"
    sha256 arm64_sequoia: "57d6c75884cc6282503cfe65936fae18737629bb30075a7a221c396de11d2abb"
    sha256 arm64_sonoma:  "6738e43c69a947c727210ea7bff0cb8062f19928c4e6df5c559b6f4764b7f3d3"
    sha256 sonoma:        "324bd9bef7096e3b947135f7a32d28d6d704a1ee535ccadafbaa1e4e15ce8068"
    sha256 arm64_linux:   "1799f08f82fa95ad2a952af049242709b02ce0a6a86a16955d8c09a6ef459090"
    sha256 x86_64_linux:  "85531cc035d66de09aa924c0579e47c589fd971bda60af0b7113daf1d6362a3b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "giflib"
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
