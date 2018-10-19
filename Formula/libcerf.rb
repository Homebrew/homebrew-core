class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "http://apps.jcns.fz-juelich.de/doku/sc/libcerf"
  url "http://apps.jcns.fz-juelich.de/src/libcerf/libcerf-1.9.tgz"
  sha256 "ee0f5a58764fa5445b916d8838086bfa2bf5bb368f8f665a35bd71dbdbedaea9"

  bottle do
    cellar :any
    sha256 "f74059a55e96d1531d1f65c0ddc095e50f35561f6d22c43bb84867f19fea5b37" => :mojave
    sha256 "d78fb0a50d8fa626174b5a484bb6dd07117585c70d9bf0deffe3be42eb350d10" => :high_sierra
    sha256 "b6a4a2fed720ad9c8982c084d6419d6a23c5a69b9e7069d1546692c56b786330" => :sierra
  end

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
