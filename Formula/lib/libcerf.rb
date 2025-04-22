class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/libcerf"
  url "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v2.5/libcerf-v2.5.tar.gz"
  sha256 "b3a5e68a30bdbd3a58e9e7c038bd0aa2586b90bbb1c809f76665e176b2d42cdc"
  license "MIT"
  version_scheme 1
  head "https://jugit.fz-juelich.de/mlz/libcerf.git", branch: "master"

  livecheck do
    url "https://jugit.fz-juelich.de/api/v4/projects/269/releases"
    regex(/libcerf[._-]v?((?!2\.0)\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9ef61782db29810efb515f681505ca8a23df43a38b14215b2ce0e6509ae900c0"
    sha256 cellar: :any,                 arm64_sonoma:  "86ef9614dca7cec2c1ad8c83ae5b94293f97f23043c11fc1b87f274274b20560"
    sha256 cellar: :any,                 arm64_ventura: "a185b08c275397fd84dbd70422521f4e0906cd99889bc86b80f185b189ade42b"
    sha256 cellar: :any,                 sonoma:        "98cb0698308f729c04e337b056b09fcdd33ed9b542de27dfe7b988ad9d6dc00f"
    sha256 cellar: :any,                 ventura:       "c0537286db1bbe87442d46cfdef96b2dec2d699f736e94ab71071fc0b782c4ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3ca8b3e01595c598f387bd54d918aeca3be38b2a363e656dd33d0a3a118e082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4d0865b2a220ff41b0db82e9709a349c4c394785e3ef8f2e729726deced5cd4"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcerf", "-o", "test"
    system "./test"
  end
end
