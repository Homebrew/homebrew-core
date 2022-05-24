class Pbc < Formula
  desc "Pairing-based cryptography"
  homepage "https://crypto.stanford.edu/pbc/"
  url "https://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz"
  sha256 "772527404117587560080241cedaf441e5cac3269009cdde4c588a1dce4c23d2"
  license "LGPL-3.0"
  head "https://repo.or.cz/pbc.git", branch: "master"

  livecheck do
    url "https://crypto.stanford.edu/pbc/download.html"
    regex(/href=.*?pbc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "2397daa1cad88180149983c0f6557b6a48fa2124c24ac78a8d95dd0af9cac8a0"
    sha256 cellar: :any, arm64_big_sur:  "ac722f3534f9cf0679f2c999353a524d822d4068d8f9877a5967fe6fbcef9f04"
    sha256 cellar: :any, monterey:       "dfe0e9676dd479513ec0cf524d6a225229de96aa058492a6319cdd914dd3509f"
    sha256 cellar: :any, big_sur:        "c14c0514c725c35d0dffbc7dc410ddc5be033e061ffc66d9c039033b0ca1e6e4"
    sha256 cellar: :any, catalina:       "83d464696ab79f463ec2dc930cbd9c3ecbdedde5c578e70a4994b2cd8fec1f6d"
    sha256 cellar: :any, mojave:         "85855bfe6dfe9a4fc0b0359f74aa7ea587283c1c724a6c4aee77972ecfc1d390"
    sha256 cellar: :any, high_sierra:    "adc712fd4cc68990b669922be5b8ab15e4d499176c09facb5b129c6d7c847262"
  end

  depends_on "gmp"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <pbc/pbc.h>
      #include <assert.h>

      int main()
      {
        pbc_param_t param;
        pairing_t pairing;
        element_t g1, g2, gt1, gt2, gt3, a, g1a;
        pbc_param_init_a_gen(param, 160, 512);
        pairing_init_pbc_param(pairing, param);
        element_init_G1(g1, pairing);
        element_init_G2(g2, pairing);
        element_init_G1(g1a, pairing);
        element_init_GT(gt1, pairing);
        element_init_GT(gt2, pairing);
        element_init_GT(gt3, pairing);
        element_init_Zr(a, pairing);
        element_random(g1); element_random(g2); element_random(a);
        element_pairing(gt1, g1, g2); // gt1 = e(g1, g2)
        element_pow_zn(g1a, g1, a); // g1a = g1^a
        element_pow_zn(gt2, gt1, a); // gt2 = gt1^a = e(g1, g2)^a
        element_pairing(gt3, g1a, g2); // gt3 = e(g1a, g2) = e(g1^a, g2)
        assert(element_cmp(gt2, gt3) == 0); // assert gt2 == gt3
        pairing_clear(pairing);
        element_clear(g1); element_clear(g2); element_clear(gt1);
        element_clear(gt2); element_clear(gt3); element_clear(a);
        element_clear(g1a);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{Formula["gmp"].lib}", "-lgmp", "-L#{lib}",
                   "-lpbc", "-o", "test"
    system "./test"
  end
end
