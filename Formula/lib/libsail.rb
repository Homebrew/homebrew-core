class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "4e46b1a5cd0e23f78fbeef085340779c9d4a7d5dd731ffd1df8fdfb343befbc4"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "3484f64110734828d3f64563db28cd67a1d74bb54c15d019a24a963aac7bb285"
    sha256 arm64_sonoma:  "ad5e80322892f6ef6440a0fa5b55a9567e11f5dc22365542e837afc0b9369a05"
    sha256 arm64_ventura: "26c3d9a1f1accade89291591d21bc7f7133a8bd7fbcec43c342b11ca993ae6ab"
    sha256 sonoma:        "976224665716c1ec70359f9ed3facea60941ed69edccc68afd469e270166dcdd"
    sha256 ventura:       "eec3868e6c14210fdd9729c77a74f863f87b9267cc76c1a2b33e75951b822dea"
    sha256 x86_64_linux:  "ab144d2b7bcb2de1bdf72c4ebf0c8b83275e3665c949e2e51a728b9ea1b54c29"
  end

  depends_on "cmake"      => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "brotli"
  depends_on "giflib"
  depends_on "highway"
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
    system bin/"sail-imaging", "decode", test_fixtures("test.png")

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
