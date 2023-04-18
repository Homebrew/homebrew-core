class Mpfi < Formula
  desc "Multiple precision interval arithmetic library"
  homepage "https://perso.ens-lyon.fr/nathalie.revol/software.html"
  url "http://perso.ens-lyon.fr/nathalie.revol/softwares/mpfi-1.5.4.tar.bz2"
  sha256 "d20ba56a8d57d0816f028be8b18a4aa909a068efcb9a260e69577939e4199752"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(/href=.*?mpfi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7401897771e7e1714d9bdf79ca0a384af06d756b2ce331a727c4253b93cae7fc"
    sha256 cellar: :any,                 arm64_monterey: "da4f0c1a2da5779a03ca4dd3c813bd6134c23687418ff5cf1f98687f0561ccb8"
    sha256 cellar: :any,                 arm64_big_sur:  "46e169bc50fe8357a928fd829d26b7879ce942d60cab5d809df75e847d5ed0e4"
    sha256 cellar: :any,                 ventura:        "f938d6da70993c3fc9ad71483ee1daf875122e87a07dcf8322f125af6ee51f9b"
    sha256 cellar: :any,                 monterey:       "a46d41cbd8e5eb649b6f33ec56eeafe79a75ec89ba7652c426e661340249a128"
    sha256 cellar: :any,                 big_sur:        "4c9a07e8889087a34c932c567b4e5f256d7d146f76206d3d62b5e2aa128f8689"
    sha256 cellar: :any,                 catalina:       "4cfd2197c9eed1b74d9518b0054d69556942e5ed7b0d3b8a6d93fffc50e95726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43395ab987d381a3f22eb91b2ce74c8a7d39623e0eac8a78f95d2e50b644b1cd"
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
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

    system ENV.cc, "test.c", "-o", "test",
                   "-L#{lib}", "-lmpfi",
                   "-L#{Formula["mpfr"].lib}", "-lmpfr",
                   "-L#{Formula["gmp"].lib}", "-lgmp"
    system "./test"
  end
end
