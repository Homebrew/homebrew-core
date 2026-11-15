class Mpfi < Formula
  desc "Multiple precision interval arithmetic library"
  homepage "https://perso.ens-lyon.fr/nathalie.revol/software.html"
  url "https://gitlab.inria.fr/mpfi/mpfi/-/archive/1.5.5/mpfi-1.5.5.tar.bz2"
  sha256 "4c5d0c43759ee3e2bd8e4ffce078e85e928925b8bea97206cdf1620b2225b463"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  compatibility_version 1
  head "https://gitlab.inria.fr/mpfi/mpfi.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ded356712f2a860073ac623621ffe8f5715272bbfcb8ad0967377556ba41ebe0"
    sha256 cellar: :any, arm64_tahoe:       "77ff8894c355116e031ae3edc9c78fb9eb963bfd499d37ffbb6265fc1816ce3d"
    sha256 cellar: :any, arm64_sequoia:     "db8707dd0d05575e06945620923ffa0115055bcb1b016922cf0d755eed43580f"
    sha256 cellar: :any, arm64_linux:       "fcf91c7bc68097cc1e8f1829ec83b652a50be2421f8c385b9603939dd63e9589"
    sha256 cellar: :any, x86_64_linux:      "6b55c2470092faf4d2d5703275ead512cdd1bc88a6d01aa289dca409493e9605"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gmp"
  depends_on "mpfr"

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <mpfi.h>

      int main()
      {
        mpfi_t x;
        mpfi_init(x);
        mpfi_clear(x);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test",
                   "-L#{lib}", "-lmpfi",
                   "-L#{Formula["mpfr"].lib}", "-lmpfr",
                   "-L#{Formula["gmp"].lib}", "-lgmp"
    system "./test"
  end
end
