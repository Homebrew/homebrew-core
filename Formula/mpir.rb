class Mpir < Formula
  desc "Multiple Precision Integers and Rationals (fork of GMP)"
  homepage "https://mpir.org/"
  url "https://mpir.org/mpir-3.0.0.tar.bz2"
  sha256 "52f63459cf3f9478859de29e00357f004050ead70b45913f2c2269d9708675bb"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://mpir.org/downloads.html"
    regex(/href=.*?mpir[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "047110a0c73f2c6224609727d07e6e581b4e7f3f57de477971b0d4e795a9af29"
    sha256 cellar: :any,                 arm64_big_sur:  "dcfb7c5e0b679f0d3cc14ec76fa3a565f8b521ba19a2d6212e6f39b27f220a6c"
    sha256 cellar: :any,                 monterey:       "8b2b3fe7672e36b0323c3fefff3cac5e68eb48b249829a23ffac5c60056b75f6"
    sha256 cellar: :any,                 big_sur:        "2364f0bb79cf8a0ef739f077eaacc7228fd89d39d18d0b9f1e135a2577472684"
    sha256 cellar: :any,                 catalina:       "884e9e0b62c809c531c55d6da43fbebadd5428976afbf95d2dc8968599e6e013"
    sha256 cellar: :any,                 mojave:         "1b930468cbd16840c9c689b8b24c91ce45a136b7512ccd06b6c13a14cd5405e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "255666a3f9f3520885fba30dbe76714a89a10d914473e6cf834f55caba125a2a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "yasm" => :build

  # Fix Xcode 12 build: https://github.com/wbhart/mpir/pull/292
  patch do
    url "https://github.com/wbhart/mpir/commit/bbc43ca6ae0bec4f64e69c9cd4c967005d6470eb.patch?full_index=1"
    sha256 "8c0ec267c62a91fe6c21d43467fee736fb5431bd9e604dc930cc71048f4e3452"
  end

  def install
    # Regenerate ./configure script due to patch above
    system "autoreconf", "--verbose", "--install", "--force"
    args = %W[--disable-silent-rules --prefix=#{prefix} --enable-cxx]
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpir.h>
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmpir", "-o", "test"
    system "./test"
  end
end
