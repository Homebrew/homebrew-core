class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz"
  sha256 "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"

  bottle do
    cellar :any
    sha256 "a28caecdb2f0759fbac1394d27fc9a0332d859c63e898493382908d85bbf9b1b" => :sierra
    sha256 "e31a716ec0cf8061660acfa6eba7b7447007a80820067b5e3c9f84b7d3cc6de5" => :el_capitan
    sha256 "6871a3bc2175ee4482e3bd7144da7d664a533a38c9452bd6f097195a90b29128" => :yosemite
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
