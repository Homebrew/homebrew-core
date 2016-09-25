class Mpfi < Formula
  desc "Multiple precision interval arithmetic library"
  homepage "https://perso.ens-lyon.fr/nathalie.revol/software.html"
  url "https://gforge.inria.fr/frs/download.php/30130/mpfi-1.5.1.tar.gz"
  sha256 "ea2725c6f38ddd8f3677c9b0ce8da8f52fe69e34aa85c01fb98074dc4e3458bc"

  bottle do
    cellar :any
    sha256 "ef61011bac358bf0434a1a9a5dfb47003c20586557590b1d8732d2baf9fab16b" => :sierra
    sha256 "9a36493cb162a66182b8792297db5b6cf32d75f9235252e215a2a6c196223f63" => :el_capitan
    sha256 "6b202dd6c288c0a2f8025050a515a9f258e4adb7d244e98514e0b3adb5636a02" => :yosemite
    sha256 "d9aaac81a9898a308063e9c2b3154a320f2ea2eb2c5c02bdf33b09a8227606c7" => :mavericks
  end

  depends_on "gmp"
  depends_on "mpfr"

  option "32-bit"

  def install
    ENV.m32 if build.build_32_bit?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <mpfi.h>

      int main()
      {
        mpfi_t x;
        mpfi_init(x);
        mpfi_clear(x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lgmp", "-lmpfr", "-lmpfi", "-o", "test"
    system "./test"
  end
end
