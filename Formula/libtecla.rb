class Libtecla < Formula
  desc "Command-line editing facilities similar to the tcsh shell"
  homepage "http://www.astro.caltech.edu/~mcs/tecla/index.html"
  url "http://www.astro.caltech.edu/~mcs/tecla/libtecla-1.6.3.tar.gz"
  sha256 "f2757cc55040859fcf8f59a0b7b26e0184a22bece44ed9568a4534a478c1ee1a"

  bottle do
    cellar :any
    sha256 "a6bbfa1cee4b62a03186d6fa1a153fceb2b3b9ae5cdf63411d6432c6251c753b" => :catalina
    sha256 "d39e8711f7a9a5a11433c7c92a2113a97f8846796f93fa7bca1281e06db2e3fe" => :mojave
    sha256 "dffae78362e21bf324ed651a2b80ff924b1bbec60916159863e66c7171072a9c" => :high_sierra
    sha256 "21cd696f6e79ae6401dd19f832ac24263f016a62c2d15ec31e25d515bbea5983" => :sierra
    sha256 "3ceb3942ea4ae1434dcc0aea00fa58b6f16787bc1a0067e9497ad4cb050f771a" => :el_capitan
    sha256 "836d6100343197540f079ea7f6b9e5641fd8efc4e331d3492f8be4cd41ced6e9" => :yosemite
    sha256 "d7f9b95bbe7540504751d42589e8500a77d15dc3e6b2f7fe501ed872172f1129" => :mavericks
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <locale.h>
      #include <libtecla.h>

      int main(int argc, char *argv[]) {
        GetLine *gl;
        setlocale(LC_CTYPE, "");
        gl = new_GetLine(1024, 2048);
        if (!gl) return 1;
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-ltecla", "-o", "test"
    system "./test"
  end
end
