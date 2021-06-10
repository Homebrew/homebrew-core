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
    sha256 cellar: :any, arm64_big_sur: "15a8c4e33a5ab62b9e2074252179a0f3dd42fbe8bb7049cfd3c10ef4b65bd885"
    sha256 cellar: :any, big_sur:       "4070cf381616416973d336313d25da53023b24cdb976db912451fbc7d165b71c"
    sha256 cellar: :any, catalina:      "45843342432e3522ca8cd9e47ab9b6a984bf1fea9069349333290cc80c1c27da"
    sha256 cellar: :any, mojave:        "4ce4182ebdf4c316518450bfcf52b813867620db0a9e4ade2faf6c65b7ede21c"
    sha256 cellar: :any, high_sierra:   "76670452623c7c3d9e110eb9a7c590e64160d9d45f55b6e4bfa02475c30556b3"
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
