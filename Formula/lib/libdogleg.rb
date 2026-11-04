class Libdogleg < Formula
  desc "Large-scale nonlinear least-squares optimization library"
  homepage "https://github.com/dkogan/libdogleg"
  url "https://github.com/dkogan/libdogleg/archive/refs/tags/v0.18.tar.gz"
  sha256 "d97ef0c149463f84e9bd40c8852da444605a38bac432b5b2774de3dd15180bab"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  depends_on "mrbuild" => :build
  depends_on "openblas"
  depends_on "suite-sparse"

  uses_from_macos "perl" => :build

  def install
    # Each project's choose_mrbuild.mk uses ./mrbuild if it exists
    mrbuild = formula_opt_include("mrbuild")/"mrbuild"
    (buildpath/"mrbuild").install_symlink mrbuild.children
    (buildpath/"mrbuild").install_symlink formula_opt_bin("mrbuild") => "bin"

    # mrbuild takes the version from git or debian/changelog, and the tarball
    # has neither. USE_DEBIAN_PATHS= skips its Debian layout guesses and files
    # the manpage under man3.
    args = %W[
      VERSION=#{version}
      USE_DEBIAN_PATHS=
      DESTDIR=#{prefix}
      INSTALL_ROOT_LIB=/lib
      INSTALL_ROOT_INCLUDE=/include
      INSTALL_ROOT_MAN=/share/man
    ]
    system "make", *args
    %w[sparse dense dense-products-packed-upper dense-products-unpacked].each do |mode|
      system "./sample", "--check", mode
    end
    system "make", "install", *args
  end

  test do
    (testpath/"test.c").write <<~C
      #include <math.h>
      #include <stdio.h>
      #include <dogleg.h>

      /* Fit y = a*exp(b*t) to points generated with a=2, b=-0.5 */
      #define N 10
      static void f(const double* p, double* x, double* J, void* cookie)
      {
        (void)cookie;
        for (int i = 0; i < N; i++) {
          double t = i, e = exp(p[1] * t);
          x[i] = p[0] * e - 2.0 * exp(-0.5 * t);
          J[2 * i + 0] = e;
          J[2 * i + 1] = p[0] * t * e;
        }
      }

      int main(void)
      {
        double p[2] = {1.0, 0.0};
        dogleg_parameters2_t params;
        dogleg_getDefaultParameters(&params);
        dogleg_optimize_dense2(p, 2, N, f, NULL, &params, NULL);
        printf("%.6f %.6f\\n", p[0], p[1]);
        return !(fabs(p[0] - 2.0) < 1e-6 && fabs(p[1] + 0.5) < 1e-6);
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-I#{formula_opt_include("suite-sparse")}",
           "-L#{lib}", "-ldogleg", "-lm", "-o", "test"
    assert_equal "2.000000 -0.500000", shell_output("./test").strip
  end
end
