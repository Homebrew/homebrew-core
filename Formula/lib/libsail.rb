class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "d02ce889b70d9e237b64806df26b044753e3edf3e87c8af42c32ec9968133a88"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "e943d9c6942c0ca812182984528772888b9d23bac0a0a16ed34f05815f0d4c71"
    sha256 arm64_ventura:  "cabc995e8be98553d783fdca095f109978de7b15134e283a47d7031087ecdeb5"
    sha256 arm64_monterey: "d3dd160f8bfe5f7d2c2d4202982cc157b502b2cadab27b5c7d2dfeeff5c8ac4e"
    sha256 sonoma:         "fa4ac696635cb4c44bdfa848942504f397762088dc9dcd8ef8931b43e6354775"
    sha256 ventura:        "1d4bdd106c22543c52be7c857decbb588776c8ad60f0b83b6fffc5a64a8bbd6f"
    sha256 monterey:       "572b22c5e1a5e77ca73f436b92a216be4a0d8ce5269a6ad816802b71697b892c"
    sha256 x86_64_linux:   "8523f9b6d40ee4de4d61602a8a640035ce7de589f6df844905824d6fda927436"
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
