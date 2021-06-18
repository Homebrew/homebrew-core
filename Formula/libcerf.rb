class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/libcerf"
  url "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v1.15/libcerf-v1.15.tar.gz"
  sha256 "a5d45475e08d431267fd29d6af987a9dd9b6792578ec3feb466d4d21f2844868"
  license "MIT"
  version_scheme 1
  head "https://jugit.fz-juelich.de/mlz/libcerf.git"

  livecheck do
    url "https://jugit.fz-juelich.de/api/v4/projects/269/releases"
    regex(/libcerf[._-]v?((?!2\.0)\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ca7341adfbe652679546e042e7d445d584fa9f8cd78dd6b5f3fd242b236f649f"
    sha256 cellar: :any, big_sur:       "4b3ffa470e65f0e05bbe261b1703e950803a2fbe78c66173d05995956dd263e5"
    sha256 cellar: :any, catalina:      "0aa906b43775d5d85898abe019c19f11f9659eaaa9b02097fc8fb616f4495bcf"
    sha256 cellar: :any, mojave:        "0e76a9b44e97130c4c5ed84a7af442318ed0c9633912bc9f85810b8bf5cb0af2"
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
