class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.83.1/leptonica-1.83.1.tar.gz"
  sha256 "8f18615e0743af7df7f50985c730dfcf0c93548073d1f56621e4156a8b54d3dd"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "457cedb4639b87cff6b170181e565c1f135977978bc1ea64733d56b549039ffd"
    sha256 cellar: :any,                 arm64_ventura:  "296fb19d6f6a934416ecc0f65789a0016ae1a500ac38bd67de50664d32da62e3"
    sha256 cellar: :any,                 arm64_monterey: "b644e4e2378628b56a2a73b321c5b24296d6fc405caa611f473faa3df7de7e15"
    sha256 cellar: :any,                 arm64_big_sur:  "8595af74ef54be9ac4ceeac23ccc90d924611fe95704e2beb159e17b317bb0ec"
    sha256 cellar: :any,                 sonoma:         "043c3d7b9eaead2deb28afe59c26b030b4680c718c208da319cbdab80d8f2dc8"
    sha256 cellar: :any,                 ventura:        "88df9cb03f737d381155e43acb70057b9542f6d77163288e11fb0fab8c8ed897"
    sha256 cellar: :any,                 monterey:       "68605d71c607a9fb5167f7a3d1e5701478f133162cfaed8b4fd6efb0e0116f23"
    sha256 cellar: :any,                 big_sur:        "e3c2af5c8374bf1f24e8c1ad2e96656a4b0476e405325855554e5e35d1c7651d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf01d5a6a61839ed96055e37d76f53a1068f94b30953c9f31c1ddaaf4bcc38a6"
  end

  depends_on "pkg-config" => :build
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "webp"

  def install
    system "./configure", *std_configure_args,
                          "--with-libwebp",
                          "--with-libopenjpeg"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <leptonica/allheaders.h>

      int main(int argc, char **argv) {
          fprintf(stdout, "%d.%d.%d", LIBLEPT_MAJOR_VERSION, LIBLEPT_MINOR_VERSION, LIBLEPT_PATCH_VERSION);
          return 0;
      }
    EOS

    flags = ["-I#{include}/leptonica"] + ENV.cflags.to_s.split
    system ENV.cxx, "test.cpp", *flags
    assert_equal version.to_s, `./a.out`
  end
end
