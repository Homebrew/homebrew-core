class GmpEcm < Formula
  desc "Elliptic Curve Method for integer factorization"
  homepage "https://gitlab.inria.fr/zimmerma/ecm"
  url "https://gitlab.inria.fr/zimmerma/ecm/-/archive/git-7.0.6/ecm-git-7.0.6.tar.gz"
  sha256 "d7f7cbfe414ae019fa0cd610685b9ad4d04d333ee3d826a05e6e5affd95ca91a"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://gitlab.inria.fr/zimmerma/ecm.git", branch: "master"

  livecheck do
    url :stable
    regex(/git[._-]v?(\d+(?:\.\d+)+)/i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gmp"

  uses_from_macos "m4" => :build

  def install
    system "autoreconf", "--force", "--install"

    args = %W[
      --with-gmp=#{Formula["gmp"].prefix}
      --enable-shared
    ]

    if OS.mac?
      # On macOS, global symbols require a leading underscore.
      # The configure script sometimes fails to detect this, leading to linker errors.
      # Ref: https://github.com/sagemath/sage/blob/31a24ce25741e1610aa90924ce637c018ee6d87d/build/pkgs/ecm/spkg-install.in#L186-L191
      args << "gmp_cv_asm_underscore=yes"
    end

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    # Test the ecm binary: factor 121 = 11 * 11
    assert_match "Factor found", pipe_output("#{bin}/ecm 100", "121\n")

    # Test linking against libecm using the P-1 method, which is
    # deterministic: P-1 with B1=5 finds 31 from 3937 = 31 * 127
    # because 31-1 = 30 = 2*3*5 is 5-smooth while
    # 127-1 = 126 = 2*3^2*7 is not.
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <gmp.h>
      #include <ecm.h>

      int main(void) {
        mpz_t n, f;
        ecm_params q;

        mpz_init_set_ui(n, 3937);
        mpz_init(f);
        ecm_init(q);

        q->method = ECM_PM1;

        int ret = ecm_factor(f, n, 5.0, q);
        if (ret <= 0 || mpz_cmp_ui(f, 31) != 0)
          return 1;

        ecm_clear(q);
        mpz_clear(f);
        mpz_clear(n);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test",
           "-I#{include}", "-L#{lib}", "-L#{Formula["gmp"].lib}",
           "-lecm", "-lgmp"
    system "./test"
  end
end
