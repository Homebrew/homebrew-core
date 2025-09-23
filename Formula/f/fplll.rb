class Fplll < Formula
  desc "Lattice algorithms using floating-point arithmetic"
  homepage "https://github.com/fplll/fplll"
  url "https://github.com/fplll/fplll/releases/download/5.5.0/fplll-5.5.0.tar.gz"
  sha256 "f0af6bdd0ebd5871e87ff3ef7737cb5360b1e38181a4e5a8c1236f3476fec3b2"
  license "LGPL-2.1-or-later"

  bottle do
    sha256                               arm64_tahoe:   "695205a1c567c9f190fa106bba08341983123bf5581b4ca39d6f4c57b536e2a6"
    sha256                               arm64_sequoia: "a25629aa8d961b12af85b7c04935f1133c8a18dee209ff4a593692e11543dc3b"
    sha256                               arm64_sonoma:  "b9bd6d1a49c4cc589234f87a12a08a24f5c4e43a5cd8a300467ef1dedfb2f05f"
    sha256                               arm64_ventura: "1d79f55394b4e2d055ca691e5618b63b84b6d0db58195222acecd5390c27eb93"
    sha256                               sonoma:        "2333676f4b1a145a78f8143882a81a9b2b9c309ae7ab2f54f4736b4c88db2cb7"
    sha256                               ventura:       "592795ee10822fe22704b9e4907af58022ac78bbdc2942a3d25c22801f265f04"
    sha256                               arm64_linux:   "5c523f0fe723a7109241c868e8970ab3a3f72aa04c8cf5a71b287153355150c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c9679fb7aa760cc54e7fb45622595f1c2364bacbd340275682292fe18fa89db"
  end

  depends_on "automake" => :build
  depends_on "pkgconf" => :test
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"m1.fplll").write("[[10 11][11 12]]")
    assert_equal "[[0 1 ]\n[1 0 ]\n]\n", `#{bin/"fplll"} m1.fplll`

    (testpath/"m2.fplll").write("[[17 42 4][50 75 108][11 47 33]][100 101 102]")
    assert_equal "[107 88 96]\n", `#{bin/"fplll"} -a cvp m2.fplll`

    (testpath/"test.cpp").write <<~CPP
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
    CPP
    pkgconf_flags = shell_output("pkgconf --cflags --libs gmp mpfr fplll").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", *pkgconf_flags, "-o", "test"
    system "./test"
  end
end
