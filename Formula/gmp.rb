class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz"
  sha256 "fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gmplib.org/download/gmp/"
    regex(/href=.*?gmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "0f98606895130c76fc827eccdcca930700d5954b7e866672ab0b69480aaab59b" => :big_sur
    sha256 "2e6acd6e62d1b8ef0800061e113aea30a63f56b32b99c010234c0420fd6d3ecf" => :catalina
    sha256 "1bbea4983a4c883c8eb8b7e19df9fab52f0575be8a34b629fc7df79895f48937" => :mojave
    sha256 "63f220c9ac4ebc386711c8c4c5e1f955cfb0a784bdc41bfd6c701dc789be7fcc" => :high_sierra
  end

  uses_from_macos "m4" => :build

  def install
    cpu = Hardware::CPU.arm? ? "aarch64" : Hardware.oldest_cpu
    system "./configure", "--prefix=#{prefix}",
                          "--enable-cxx",
                          # Enable --with-pic to avoid linking issues with the static library
                          "--with-pic",
                          "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gmp.h>
      #include <stdlib.h>

      int main() {
        mpz_t i, j, k;
        mpz_init_set_str (i, "1a", 16);
        mpz_init (j);
        mpz_init (k);
        mpz_sqrtrem (j, k, i);
        if (mpz_get_si (j) != 5 || mpz_get_si (k) != 1) abort();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-o", "test"
    system "./test"

    # Test the static library to catch potential linking issues
    system ENV.cc, "test.c", "#{lib}/libgmp.a", "-o", "test"
    system "./test"
  end
end
