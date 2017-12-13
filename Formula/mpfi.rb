class Mpfi < Formula
  desc "Multiple precision interval arithmetic library"
  homepage "https://perso.ens-lyon.fr/nathalie.revol/software.html"
  url "https://gforge.inria.fr/frs/download.php/file/37307/mpfi-1.5.2.tar.bz2"
  sha256 "c04f52cb306824b91b6d6eacf4f675b91fdee47c30f14d5b346dbfcd2492d274"

  bottle do
    cellar :any
    sha256 "8240e74f03f35c775a467df6749c71a348832c81139de0f18b3777d10ec065bd" => :high_sierra
    sha256 "ef61011bac358bf0434a1a9a5dfb47003c20586557590b1d8732d2baf9fab16b" => :sierra
    sha256 "9a36493cb162a66182b8792297db5b6cf32d75f9235252e215a2a6c196223f63" => :el_capitan
    sha256 "6b202dd6c288c0a2f8025050a515a9f258e4adb7d244e98514e0b3adb5636a02" => :yosemite
    sha256 "d9aaac81a9898a308063e9c2b3154a320f2ea2eb2c5c02bdf33b09a8227606c7" => :mavericks
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
