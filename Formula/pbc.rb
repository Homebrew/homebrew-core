class Pbc < Formula
  desc "Pairing-based cryptography"
  homepage "https://crypto.stanford.edu/pbc/"
  url "https://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz"
  sha256 "772527404117587560080241cedaf441e5cac3269009cdde4c588a1dce4c23d2"
  head "https://repo.or.cz/pbc.git"

  bottle do
    cellar :any
    sha256 "3d34df3cd1f1d357a3893f53d19496721d3dfb04b86b1d22b87fb88df27746c1" => :mojave
    sha256 "f737a917951f31a9477b2ee46761eb3d9323ca96d77b5b0ab78d7566eb743213" => :high_sierra
    sha256 "9ec971f355f67d0faf644e955a26e9a86b667066eac0791288b802bbe7c0f4aa" => :sierra
    sha256 "5295bb2d5b2698685ff7ff8b64e0578a5b8c9b9f9602fc51583cae058ee24b81" => :el_capitan
    sha256 "5ec07e1b5752aa02b6a479665ca8a57b85ed55d5cd3b05a34cf403d7b47ea142" => :yosemite
    sha256 "3be60cf755e2d568867c2d5c53a46774627afe1fe7439b7f86437e718ba52ed8" => :mavericks
    sha256 "f9f7455441a38df308bd433f1a13a208ef65a2081a1884f45156f3b63072c832" => :mountain_lion
  end

  depends_on "gmp"

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
    system ENV.cc, "test.c", "-lgmp", "-L#{lib}", "-lpbc", "-o", "test"
    system "./test"
  end
end
