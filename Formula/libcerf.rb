class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/libcerf"
  url "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v2.2/libcerf-v2.2.tar.gz"
  sha256 "bf9e3c4707a49f27edc1891b1a8668a0cf5320741dcd84311d83f9af78249069"
  license "MIT"
  version_scheme 1
  head "https://jugit.fz-juelich.de/mlz/libcerf.git", branch: "master"

  livecheck do
    url "https://jugit.fz-juelich.de/api/v4/projects/269/releases"
    regex(/libcerf[._-]v?((?!2\.0)\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "70dd7c4019e0fe3d63aeb87035a158ffe50c8f8e73fcd1e5c0ff1c6b3a9fa489"
    sha256 cellar: :any,                 arm64_monterey: "713741dafcc990ebc5523ccbf3cf60f34cca89bcd847e0a1528ea36d053ad646"
    sha256 cellar: :any,                 arm64_big_sur:  "72addbfa1361c4080e66a9521021f4ecf7e8831563a4d92893ad058ef0db4878"
    sha256 cellar: :any,                 monterey:       "c8550dab94475bbcbe33785f1af4a23170062a93c4f20c2093a543de20e7e637"
    sha256 cellar: :any,                 big_sur:        "26dab60aa06f6189616673601eb30667be5ee350dbdc91e3e73480f927c50cc3"
    sha256 cellar: :any,                 catalina:       "632421289d60a3b761094b318c21f078b595d50c5198942cac0c8e9182042982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53ef7134564a68c78a30a89d79d0cbb3f6b46b9a4dc5d420ef37c33ec5eb19f4"
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
