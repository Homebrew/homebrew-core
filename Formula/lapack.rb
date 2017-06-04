class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "http://www.netlib.org/lapack/"
  url "http://www.netlib.org/lapack/lapack-3.7.0.tgz"
  sha256 "ed967e4307e986474ab02eb810eed1d1adc73f5e1e3bc78fb009f6fe766db3be"
  revision 3
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    sha256 "9013bc0a104d3d3163155cadbbf847d94e53513fe569bf8d9262977b9d192c0f" => :sierra
    sha256 "7ebe016039ef1ba945a049a51449a245242df8300ac178547f240d624c1f3e7c" => :el_capitan
    sha256 "fa4a66bf44fce6ced094c29b10632cb99368bff26818455eb6147de3edffc4d1" => :yosemite
  end

  keg_only :provided_by_osx

  depends_on "cmake" => :build
  depends_on :fortran
  depends_on "gcc"

  def install
    mkdir "build" do
      system "cmake", "..",
                      "-DBUILD_SHARED_LIBS:BOOL=ON",
                      "-DLAPACKE:BOOL=ON",
                      *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"lp.cpp").write <<-EOS.undent
      #include "lapacke.h"
      int main() {
        void *p = LAPACKE_malloc(sizeof(char)*100);
        if (p) {
          LAPACKE_free(p);
        }
        return 0;
      }
    EOS
    system ENV.cc, "lp.cpp", "-I#{include}", "-L#{lib}", "-llapacke", "-o", "lp"
    system "./lp"
  end
end
