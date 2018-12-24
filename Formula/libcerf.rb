class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "http://apps.jcns.fz-juelich.de/doku/sc/libcerf"
  url "http://apps.jcns.fz-juelich.de/src/libcerf/libcerf-1.10.tgz"
  sha256 "6a412c13e404411d77105c731a756384970424d6f65d1c4c63758c28183d4b61"

  bottle do
    cellar :any
    sha256 "5b7e0dda5ba845088c39b6c31271fc7fd96069e5a7f8e0e3049e06e18bf86533" => :mojave
    sha256 "6460726dcb41a15a6e60d58890ae524baebe3d53ff487bc551bdb49a0a1909a6" => :high_sierra
    sha256 "a8d859a1b795c6c96fffee2e104339639e3662b2d1fb0fa801a69aef3035f84c" => :sierra
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
