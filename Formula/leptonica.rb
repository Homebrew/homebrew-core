class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "http://www.leptonica.org/source/leptonica-1.82.0.tar.gz"
  sha256 "155302ee914668c27b6fe3ca9ff2da63b245f6d62f3061c8f27563774b8ae2d6"
  license "BSD-2-Clause"
  revision 2

  livecheck do
    url "http://www.leptonica.org/download.html"
    regex(/href=.*?leptonica[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bbe2eadbb1a026605be6e25cc2380781014089bc045d6de7b82d8732ce98f755"
    sha256 cellar: :any,                 arm64_monterey: "df900711040809d37fbd4da3ffc19e6649cb746437ec00de15ad5952c7788568"
    sha256 cellar: :any,                 arm64_big_sur:  "22c929151699d47a256dec0ed65a3b17632a2b7bf449c4a08e5d1d7c948d053a"
    sha256 cellar: :any,                 ventura:        "3faca0f2994817bf481c43509fa6b342b35e3ee48871a6ab504b51068df73b85"
    sha256 cellar: :any,                 monterey:       "8c0edbcdb903f2b6d33caa64bdd69ab5a19df1d026b2c3bd701bec325b0e9db8"
    sha256 cellar: :any,                 big_sur:        "84fec88e3f5c331b22e94a187a66d11818e4bcb04073515bea4f9d2242766bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c002d8bc874be1e7e0dce47586f33b776e4cfba7411406eb3530a3a946301d6d"
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
