class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "31e7944eb685b7ffcc25a974b8a1f01f3b7ebd86ebe6f49eb8d011eac9368bd5"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "d461d52ce6fe6a4278efb4387dff0f8f5d5987b36a972cad2321b9912015f756"
    sha256 arm64_ventura:  "cc3d484f016a3244c1cb7225d18ef0a21eafc79a5faaa322e98d24f442bb5a81"
    sha256 arm64_monterey: "9ddc35fa7fdb914bf2244be33a79cbc28034f1ef8ea75aeb45de8c900140c5f2"
    sha256 sonoma:         "2fae344dfc26b153235e5182f2e23217227957bf25f4722dcf8e724fa89fe760"
    sha256 ventura:        "181a10e710914a5d9c340106e5b12e312388cd9e4172da926d39c4ed0cfdcfad"
    sha256 monterey:       "188612ba23f77cb981281e3a8c138fadc238b4391e5830a3ffa5a585b09dafa6"
    sha256 x86_64_linux:   "0f38973edb7d134856b601bc91c690f1c51fa03e251e00eedb9d6124b260e7f5"
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
