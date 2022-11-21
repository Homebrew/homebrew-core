class Fplll < Formula
  desc "Lattice algorithms using floating-point arithmetic"
  homepage "https://github.com/fplll/fplll"
  url "https://github.com/fplll/fplll/releases/download/5.4.2/fplll-5.4.2.tar.gz"
  sha256 "6e7b1704fd56f29dd9fc1dd719cc1f2df1f58964fd77bbde162f594d7fff7ba5"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "6b4c2dbeed3ebe441c0f5d207c4696d6f174c67534848f439b637abcaccd4c5f"
    sha256 arm64_monterey: "414ee65d613528dd9a06be25332d02380947f6c59dcd9748c2f37ccbc488abf8"
    sha256 arm64_big_sur:  "0905f8ae083002a515a21e432e2791c9bedcec86d484a5a2aa6f346c97dab676"
    sha256 ventura:        "693a3f36163799ff52438065eac2f860f2bf39478402e78be6f80fc5697e5e34"
    sha256 monterey:       "c938c1e07f6a68c06c7067769c09fe74c1cb871b9469cb10e6f65de319629427"
    sha256 big_sur:        "79194ecb9a976d2a2e9a706243c6228315c3b359502047126fddf9954e37ed5c"
    sha256 catalina:       "18d1d69b5cdf78dd4df55b830c072c785c4d70e1e198c3797c5cc90438d5e17f"
    sha256 x86_64_linux:   "ad4a0f31e4cacd074b206095aa2d6b51db3a3b344f454d7b837ecae2a1d8bcff"
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
