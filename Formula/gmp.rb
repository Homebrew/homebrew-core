class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz"
  sha256 "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"

  bottle do
    cellar :any
    sha256 "7ff60fa13a22a22503566229b3e6b36244900a0ec6f5f897c18a7ef48f44b274" => :sierra
    sha256 "3d404810952ae59470709709f0b64e4122520afcbb65633d449bcca546f3ca41" => :el_capitan
    sha256 "8858a1e22d62875d5424b354302c818b194c8d21a669287d0e0b190816be32e9" => :yosemite
    sha256 "b604a20e2501a10773abc384d9750fa27112cf9ad9c532367ebd7caf241c8d4b" => :mavericks
  end

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    args = ["--prefix=#{prefix}", "--enable-cxx"]

    # https://github.com/Homebrew/homebrew/issues/20693
    args << "--disable-assembly" if build.bottle?

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
