class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/libcerf"
  url "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v1.17/libcerf-v1.17.tar.gz"
  sha256 "b1916b292cb37f2d0d0b699fbcf0fe260cca97ec7266ea20ff0c5cd8ef2eaab4"
  license "MIT"
  version_scheme 1
  head "https://jugit.fz-juelich.de/mlz/libcerf.git"

  livecheck do
    url "https://jugit.fz-juelich.de/api/v4/projects/269/releases"
    regex(/libcerf[._-]v?((?!2\.0)\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fb7e498e7fa1763ff17623233f6fa0a99034fcf47f47c4de073de42c00067299"
    sha256 cellar: :any,                 arm64_big_sur:  "b556c15568b822024dcb8bb43f348ce96190dadb06a92daf4a7bdc6d2bb952c7"
    sha256 cellar: :any,                 monterey:       "67d445f7fe88fd85b9dc07e772cc5c7e802d5032e1885b14178c8c79399aabcd"
    sha256 cellar: :any,                 big_sur:        "3c23b5b1d35053a0378674aa6d6c5668a4b36be61382b7974d284dcfa17cdde7"
    sha256 cellar: :any,                 catalina:       "9d0409617477f3c400ef771c2b8c9b3eb46faeda7608f2a3200dcf7a69eb8c80"
    sha256 cellar: :any,                 mojave:         "7dc6c5eff9c002bda2fc9790cba55fa81965da5298f5666542fdd3717b751d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8143e570f28eb8f2d413dc4269992663f762509b4f0f3a5fa3064260baec2660"
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
