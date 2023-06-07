class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/libcerf"
  url "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v2.3/libcerf-v2.3.tar.gz"
  sha256 "cceefee46e84ce88d075103390b4f9d04c34e4bc3b96d733292c36836d4f7065"
  license "MIT"
  version_scheme 1
  head "https://jugit.fz-juelich.de/mlz/libcerf.git", branch: "master"

  livecheck do
    url "https://jugit.fz-juelich.de/api/v4/projects/269/releases"
    regex(/libcerf[._-]v?((?!2\.0)\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a5af0663e797d2634835277e1316894d4b52c86ba2290045e386a75a32fb790f"
    sha256 cellar: :any,                 arm64_monterey: "7c5953ca89e4a87846cb36b64bc6a47acb2b6c74c913cede5e5a29eb61463a10"
    sha256 cellar: :any,                 arm64_big_sur:  "b8f41b3d364035d9440a1f9a6cb4dd4ef821df94487e3c9f11076ab4ac3e85cc"
    sha256 cellar: :any,                 ventura:        "27cac98b6c028053369bc89e6fabab0768dc7aee9ade40b8073484afaa469d47"
    sha256 cellar: :any,                 monterey:       "16f8d9973dab633e5e759547c9029f8384bde177b5fce1cdb79ac4ed796e5b1b"
    sha256 cellar: :any,                 big_sur:        "eb5e99339b766382160475399db448f795a7c1c1cab2600dca982527cfc3c4e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c10a47d01e826e5c185efbeec58e1a9f3f4630547954c5781b5b8522f44afa18"
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
