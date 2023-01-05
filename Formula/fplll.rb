class Fplll < Formula
  desc "Lattice algorithms using floating-point arithmetic"
  homepage "https://github.com/fplll/fplll"
  url "https://github.com/fplll/fplll/releases/download/5.4.4/fplll-5.4.4.tar.gz"
  sha256 "0fd9d378f04ff886d8864728baf5d90b8b0b82c1e541e92550644fb54f75691d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256                               arm64_ventura:  "7a5959521c876aed29742a738728b7c7bfa5d1ad2315347feebc1377b3ad4ff6"
    sha256                               arm64_monterey: "3ba1dfcca3b1b574d96ee070345fe1f4ff1ff64f1168a7ba7c5824d609a06ec5"
    sha256                               arm64_big_sur:  "d35475cea0b4d09c295bee7fff000212326fb5434d09af1eb039d9f2dd21c835"
    sha256                               ventura:        "6511ac8e85961b4c84b5109500fb57c89f6dc450d2d13f08fb6df3d8d0e8e35f"
    sha256                               monterey:       "faa8b1c5f86ece266b726246dd2614041e369916a1b732183ea8a66a9118fe8a"
    sha256                               big_sur:        "bd64e8930e222533b94e6ac862fc4efc39dac5776489cadde16a77cefda23440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2da213da7edfafbf5e2ae3d778683fb3750827ae758991d6abdf00f016ceef3"
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
      using namespace fplll;
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
