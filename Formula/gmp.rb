class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.1.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.1.1.tar.xz"
  sha256 "d36e9c05df488ad630fff17edb50051d6432357f9ce04e34a09b3d818825e831"

  bottle do
    cellar :any
    sha256 "7ff60fa13a22a22503566229b3e6b36244900a0ec6f5f897c18a7ef48f44b274" => :sierra
    sha256 "3d404810952ae59470709709f0b64e4122520afcbb65633d449bcca546f3ca41" => :el_capitan
    sha256 "8858a1e22d62875d5424b354302c818b194c8d21a669287d0e0b190816be32e9" => :yosemite
    sha256 "b604a20e2501a10773abc384d9750fa27112cf9ad9c532367ebd7caf241c8d4b" => :mavericks
  end

  option "32-bit"
  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    args = ["--prefix=#{prefix}", "--enable-cxx"]

    if build.build_32_bit?
      ENV.m32
      args << "ABI=32"
    end

    # https://github.com/Homebrew/homebrew/issues/20693
    args << "--disable-assembly" if build.build_32_bit? || build.bottle?

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gmp.h>

      int main()
      {
        mpz_t integ;
        mpz_init (integ);
        mpz_clear (integ);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-o", "test"
    system "./test"
  end
end
