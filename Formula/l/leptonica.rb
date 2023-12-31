class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.84.0/leptonica-1.84.0.tar.gz"
  sha256 "42a029312a1df0cd5640195a979be81bf66230e153164cac456478454e7206d5"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4244107ea7dd15a0c2e0e818a29f523dfee4d4a78ecf0713d001d82f4dc5a90e"
    sha256 cellar: :any,                 arm64_ventura:  "f8f270bb08c10b81bcf441e3e69c392b835dd307a4b6fd955de8ac2e458356e6"
    sha256 cellar: :any,                 arm64_monterey: "f0725b0fca9bb3d2a8987b185162d17d723c4ccd268f700dfea6781cc7e36628"
    sha256 cellar: :any,                 sonoma:         "28d0b8090baeac4d6e609d24f7ac85ef163860b6ddb6b9e6d50f4f810040bdf1"
    sha256 cellar: :any,                 ventura:        "5d55d5532d7dce197cec514fc87825d56354d7e79cd8e1b8955f7a704e767cd9"
    sha256 cellar: :any,                 monterey:       "2ce8493a3ca1e1b6d25cdd1bbfb18bec07725ec634770965eb0cc47f013b3f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0866610ccf91d2791c72d3f5076c8136696f8034001cd1f2b683588a5dcfd63"
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
