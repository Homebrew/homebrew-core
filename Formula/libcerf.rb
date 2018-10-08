class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "http://apps.jcns.fz-juelich.de/doku/sc/libcerf"
  url "http://apps.jcns.fz-juelich.de/src/libcerf/libcerf-1.8.tgz"
  sha256 "b2001dc594e9d85e2f4133fec52b4f7da02e9c2ea20518175fdebf5c81dd3857"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"

      mv prefix/"man", share
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
