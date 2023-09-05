class Fplll < Formula
  desc "Lattice algorithms using floating-point arithmetic"
  homepage "https://github.com/fplll/fplll"
  url "https://github.com/fplll/fplll/releases/download/5.4.4/fplll-5.4.4.tar.gz"
  sha256 "0fd9d378f04ff886d8864728baf5d90b8b0b82c1e541e92550644fb54f75691d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256                               arm64_ventura:  "1ba1a1085084572ef340831e6a3ac9bde2cf6cda68e71075ccd8e1ee05dfa5ec"
    sha256                               arm64_monterey: "f6b54eef42956eb6d47951a5050fe5b38a420fc160086d20e38751d113b896ef"
    sha256                               arm64_big_sur:  "ce9be65f08ef8ecb291ae15916ca0d1cb6f160b09629649739754b93300f7717"
    sha256                               ventura:        "2b19d4550c1ba260b0a4d8809d9ad6e4db767d53243ed4b974020628fb693070"
    sha256                               monterey:       "3c4eb9b7a09063287a71ffae596ddbd13d515e3cd13e4253e6bc7dd082f7935d"
    sha256                               big_sur:        "c63834cc0c9dd96522545abbe3e68459b019910e59cc42692c053f56991d8098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4550c39058db9b126338325f9ee65a93e13bc39336a96c5a5805d08d740d930f"
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
