class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/libcerf"
  url "https://jugit.fz-juelich.de/mlz/libcerf/uploads/924b8d245ad3461107ec630734dfc781/libcerf-1.13.tgz"
  sha256 "011303e59ac63b280d3d8b10c66b07eb02140fcb75954d13ec26bf830e0ea2f9"

  bottle do
    cellar :any
    sha256 "eef861f3d750d45f7190b65afd3cc1460c7461d5b10978790cf9b66f736e3d52" => :catalina
    sha256 "a181d4bf63f5ad9a5f00268a8551e7d62c52e81a88b9e9a29dba148d1a16412f" => :mojave
    sha256 "48ac5501edc4e90465af39ae8ff57234993f5b9b9f4b08fd8ba00443fd5d977b" => :high_sierra
    sha256 "401e716456c99bb123252b2f256e6fc70d6a741a23c8bd16d1a2ae0998641387" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcerf", "-o", "test"
    system "./test"
  end
end
