class Fplll < Formula
  desc "Lattice algorithms using floating-point arithmetic"
  homepage "https://github.com/fplll/fplll"
  url "https://github.com/fplll/fplll/releases/download/5.4.1/fplll-5.4.1.tar.gz"
  sha256 "7bd887957173aa592091772c1c36f6aa606b3b2ace0d14e2c26c7463dcf2deb7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "c1b9a32a5c3bb69d36bcaabc02be954994327c5af0c730754d9fccb8d036990c"
    sha256 arm64_big_sur:  "377b5606bb5c319ad73824afcc907f946a1c7c60ddb5a0e181d257fcafc5c5ce"
    sha256 monterey:       "f76e9a6cce440bc8651b8e699067078c7673c371dd85a758909e8333ab1241bd"
    sha256 big_sur:        "6290a0d579e8ffba1dab159d70f9e10f58d6600cad8564469fe066b24aa8f170"
    sha256 catalina:       "bf39fa78c92642f571b4514a61ebe43c5aef39ff25d0e4de969cbf6bf323cc11"
    sha256 mojave:         "2219fe4523fced68e1f9a8038848cf54d0588cc652229bcbf2bf03e696f7b971"
    sha256 x86_64_linux:   "fca671625e1f741805cc846d31b03a23506180343dcbe3393cb73a61282703df"
  end

  depends_on "automake" => :build
  depends_on "pkg-config" => :test
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"m1.fplll").write("[[10 11][11 12]]")
    assert_equal "[[0 1 ]\n[1 0 ]\n]\n", `#{bin/"fplll"} m1.fplll`

    (testpath/"m2.fplll").write("[[17 42 4][50 75 108][11 47 33]][100 101 102]")
    assert_equal "[107 88 96]\n", `#{bin/"fplll"} -a cvp m2.fplll`

    (testpath/"test.cpp").write <<~EOS
      #include <fplll.h>
      #include <vector>
      #include <stdio.h>
      int main(int c, char **v) {
        ZZ_mat<mpz_t> b;
        std::vector<Z_NR<mpz_t>> sol_coord;
        if (c > 1) { // just a compile test
           shortest_vector(b, sol_coord);
        }
        return 0;
      }
    EOS
    system "pkg-config", "fplll", "--cflags"
    system "pkg-config", "fplll", "--libs"
    pkg_config_flags = `pkg-config --cflags --libs gmp mpfr fplll`.chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", *pkg_config_flags, "-o", "test"
    system "./test"
  end
end
