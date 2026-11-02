class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/lib/cerf"
  url "https://jugit.fz-juelich.de/mlz/lib/cerf/-/archive/v3.9/cerf-v3.9.tar.bz2"
  sha256 "a227f03379c8d811ef80c7e9b4c8fdac6bed696602cb38dff026c29cb012dbf7"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://jugit.fz-juelich.de/mlz/lib/cerf.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "955821a4bdb1937c1703fb07c743dd052b37b6274b8b71c89932f9cef4a8a540"
    sha256 cellar: :any, arm64_tahoe:       "1d21b22ae2bdca5e41f98321291b3dec3f679ca50bfdd8342ae6c1a47fc16c5d"
    sha256 cellar: :any, arm64_sequoia:     "c6520942d4bf1e8d8128aeb5a198684c9bd4cee1870142dd3a921fe3c7ea0c18"
    sha256 cellar: :any, arm64_linux:       "3d410d47f56feadfa0faf23e3232bd4b8b7c69ac6f0e7847cfcf1d733db9505e"
    sha256 cellar: :any, x86_64_linux:      "e4579e9349ac9126af7d8fd42f4e8747151f4670988ccf40b42f5a657a62e2a5"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <cerf.h>
      #include <complex.h>
      #include <math.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main (void) {
        double _Complex a = 1.0 - 0.4I;
        a = cerf(a);
        if (fabs(creal(a)-0.910867) > 1.e-6) abort();
        if (fabs(cimag(a)+0.156454) > 1.e-6) abort();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcerf", "-o", "test"
    system "./test"
  end
end
