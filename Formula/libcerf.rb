class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "http://apps.jcns.fz-juelich.de/doku/sc/libcerf"
  url "http://apps.jcns.fz-juelich.de/src/libcerf/libcerf-1.11.tgz"
  sha256 "70101cac4a0d7863322d4d06cf95c507a9cfd64fc99ad1b31a8425204cfd9672"

  bottle do
    cellar :any
    sha256 "032478d9411816ebf4c6facbadcf75609fa3763ac277f4b1ab5ceadfc0f25355" => :mojave
    sha256 "df95404c20f92cfe57cd83e7bc1d29e1545ebfc13e923a56979c2acd0a5dc64e" => :high_sierra
    sha256 "ec375835ffe7b858f2a5b7fa99a4e76dcbc64453b342a60107413fb40af22e5c" => :sierra
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
