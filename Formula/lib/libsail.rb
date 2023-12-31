class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "892738e0f56fed8c6387e1045bba2bfbf1b095024a495845d4879edb310cd1a7"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "0310e1610e101b1a6ffe17a0338f503068152e96051663bf4e1ee7be63141258"
    sha256 arm64_ventura:  "d4c4494897180daf43f715450d8ea159e59360c97cc6bd1cf818d215b1d2a011"
    sha256 arm64_monterey: "60c470960b45f008fdb202d2bf572c531255c797bc87b06a67acadc8173d65e6"
    sha256 sonoma:         "6962b2f4bd8b32712e99f32da4397ee71347535f63f157942e739620ed0fecee"
    sha256 ventura:        "8a3c6ab38e7ef4a3410387a268cb3d807a23465e02578bf6fe18ba7fc0445793"
    sha256 monterey:       "5e8863c9085da955b57c8233931c3c0604efe2998cb9d77b1429962d4bd8e817"
    sha256 x86_64_linux:   "c0cee20889e40120f790541f0dd096ac94ba02f4245454b3a31712454e33ea65"
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
