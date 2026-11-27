class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/refs/tags/v1.3.16.tar.gz"
  sha256 "90f717a8e7fb212430d7fe5265ecc7ea24f669e4613e2a920fb9b1d3be9209d1"
  license "Minpack"
  compatibility_version 1
  head "https://github.com/devernay/cminpack.git", branch: "master"

  bottle do
    manifest_sha256 "91d7c52cbce1a61d96aea538ed2b49306ca06623eaa4bae50d64efaa39c2bb74"
    sha256 cellar: :any, arm64_golden_gate: "18a60e267697f7556b78b776e55968d1e5adc7eb8f2f5259d96ad4a410af330a"
    sha256 cellar: :any, arm64_tahoe:       "3ac84c4ef83cff7ceb7fa742edf14fb0970b8a63489989405af5aee05bea427c"
    sha256 cellar: :any, arm64_sequoia:     "ad9feca5fe9f0fe387c473f52fc30d610e2b2989aca56749e9787190dcbcad87"
    sha256 cellar: :any, arm64_linux:       "732e273ed55867e7bdb577b7fea995d05dd302300aab5246fc1799d46301aed6"
    sha256 cellar: :any, x86_64_linux:      "9bdc45e79620b84c25a4ff96681ba93e0bc1adb40458275f533a4816ac4326a3"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCMINPACK_LIB_INSTALL_DIR=lib
      -DBUILD_EXAMPLES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    man3.install Dir["docs/*.3"]
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <cminpack.h>

      int main() {
          int m = 2;
          int n = 2;
          double x[2] = {-1.2, 1.0};
          double fvec[2] = {0};
          double fjac[4] = {0};
          double tol = 1e-8;
          int info = -1;
          int ipvt[2] = {0};
          int ldfjac = 2;
          int lwa = m * n + 5 * n + m;
          double wa[lwa];

          for (int i = 0; i < lwa; i++) {
              wa[i] = 0;
          }

          info = lmder1(NULL, NULL, 0, n, x, fvec, fjac, ldfjac, tol, ipvt, wa, lwa);

          if (info >= 0) {
              printf("Success: lmder1 returned %d\\n", info);
          } else {
              printf("Error: lmder1 returned %d\\n", info);
          }

          return info;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/cminpack-1",
                   "-L#{lib}", "-lcminpack", "-lm", "-o", "test"
    system "./test"
  end
end
