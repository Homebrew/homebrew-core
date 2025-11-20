class Pbc < Formula
  desc "Pairing-based cryptography"
  homepage "https://crypto.stanford.edu/pbc/"
  url "https://crypto.stanford.edu/pbc/files/pbc-1.0.0.tar.gz"
  sha256 "18275a367283077bafe35f443200499e3b19c4a3754953da2a1b2f0d6b5922dc"
  license "LGPL-3.0-only"

  livecheck do
    url "https://crypto.stanford.edu/pbc/download.html"
    regex(/href=.*?pbc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9aa4953390dd8fc51665f703e72ed82c6d643a75f975cce1339ddb280d212d2"
    sha256 cellar: :any,                 arm64_sequoia: "540e6c2c25f64b9f01683b78101895359c1e317f0c040e1d6dcae389414faff7"
    sha256 cellar: :any,                 arm64_sonoma:  "5c83b34f16294a88154eb2ca05a38730aafd3426dc5680ce92426e6377ee1f28"
    sha256 cellar: :any,                 arm64_ventura: "b45ad43cbfe26bf2a5afd507c6f9dba996b7069635d04321466eec6805f64a64"
    sha256 cellar: :any,                 sonoma:        "87458237aa1d5e59deff3fde34155d58eba87df565e7f6c924f81171a6a634be"
    sha256 cellar: :any,                 ventura:       "339f7b3535980d063d87c42b9a22fc2b6ca882857347358f207bf6d9b8cd768e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bae3b376382982b1575a9f8b67b1cc476bedca4029a88cdb42f3407c8710f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77d9e6a22ef1c9a1253703a33e6c734aa3c223a031cf17cec702bc1f9c8d5834"
  end

  head do
    url "https://repo.or.cz/pbc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    # fix flex yywrap function detection issue
    ENV["ac_cv_search_yywrap"] = "yes"

    system "./setup" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
        element_clear(g1); element_clear(g2); element_clear(gt1);
        element_clear(gt2); element_clear(gt3); element_clear(a);
        element_clear(g1a);
        pairing_clear(pairing);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{Formula["gmp"].lib}", "-lgmp", "-L#{lib}",
                   "-lpbc", "-o", "test"
    system "./test"
  end
end
