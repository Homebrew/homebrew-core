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
    sha256 cellar: :any,                 arm64_ventura:  "fa41458119994c07e7dcdc650e69b5782fe8450c52c8aac4ea23fc206c30a05b"
    sha256 cellar: :any,                 arm64_monterey: "5e911b27e66690071fde7d80d1f2bc010f3c63fbc594ac60ce95a07973bb95be"
    sha256 cellar: :any,                 arm64_big_sur:  "c48cf84abbe84a2ddb979ac2e438db7c1e9430ebc510b7a392790ba106c65e22"
    sha256 cellar: :any,                 ventura:        "6470761e41d0d6738d5b4ca919209b91dbe5bb7fa0fcbaf98dd6c07371d4ed35"
    sha256 cellar: :any,                 monterey:       "72e075dea708ddfdc1421d3aa59abe811b9024c53310d22228fb8ac38e48a8aa"
    sha256 cellar: :any,                 big_sur:        "ffb6465359a84cbb5f5a2bc4fb4594c32edd3a4f6abe546c64fabaabf04d2468"
    sha256 cellar: :any,                 catalina:       "566b28dd486d974946aef516e2f91f9c3266417c64c36aaf86158126e0fa7c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef9a8ba1001d2e9ddae5382f2f5d9d5db39c4ba5a2287bcb84a9631df338153d"
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
