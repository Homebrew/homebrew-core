class Mpfi < Formula
  desc "Multiple precision interval arithmetic library"
  homepage "https://perso.ens-lyon.fr/nathalie.revol/software.html"
  url "https://gforge.inria.fr/frs/download.php/file/37331/mpfi-1.5.3.tar.bz2"
  sha256 "2383d457b208c6cd3cf2e66b69c4ce47477b2a0db31fbec0cd4b1ebaa247192f"

  bottle do
    cellar :any
    sha256 "4909b40d8a9d03a12550ce84ddf60a031898505f43446ba16316b352df8a1faf" => :mojave
    sha256 "cf0a5912aafe1a39c596d9303f12361e403f96bd52c25db6aaee1dd9a6139360" => :high_sierra
    sha256 "81e48e4445dbe6e7fa4ede18ba9c5a7a75c8816d3b0268333d4535afa4b5e7cd" => :sierra
    sha256 "9345063d6fdde9da2d16c233251300aa563668ab17675dd2dc11e4c75de88fb4" => :el_capitan
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpfi.h>

      int main()
      {
        mpfi_t x;
        mpfi_init(x);
        mpfi_clear(x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lgmp", "-lmpfr", "-L#{lib}", "-lmpfi",
                   "-o", "test"
    system "./test"
  end
end
