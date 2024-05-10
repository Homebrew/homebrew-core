class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "9a8b93c15c4a1afe07c760d2087895a18626034f55917f333aaabe9c9704438f"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "06af4232cf0664b0f70346822b5ad41cd73aa40ab427e2023416b11a8f39b3ce"
    sha256 arm64_ventura:  "1ac6b47a86abd99cdca0b4436a4709361fdbc2b855b2d0765f437c4a5fe9b2ee"
    sha256 arm64_monterey: "d6a3f51c67d4cf6dffa62ba5df2ebd80fe40d0258572473c5d0f65672e6f8b38"
    sha256 sonoma:         "04ccfdd2b34f2a53fe56187d16864edc3ca1c50e14d7ccabf41cd3983f08585d"
    sha256 ventura:        "e1160d699fb68e44d953fd2fee135e91eb0ff9982f17f4a817c93cca2735442f"
    sha256 monterey:       "ba4679b8f1224d78b7b605da210eb4d412c698ae6efc0fc045b9d7a342de4647"
    sha256 x86_64_linux:   "833439de055562b6a419822a7fefbc6b42930e535f5a01ae7a75748fd9c4feee"
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
