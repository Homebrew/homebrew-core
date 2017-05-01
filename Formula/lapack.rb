class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "http://www.netlib.org/lapack/"
  url "http://www.netlib.org/lapack/lapack-3.7.0.tgz"
  sha256 "ed967e4307e986474ab02eb810eed1d1adc73f5e1e3bc78fb009f6fe766db3be"
  revision 3
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    sha256 "26a40d104a1eb3aa734306a5fdadc5b45010a4b9414e95572cc6abe6433bb9a4" => :sierra
    sha256 "c4e22f5cf4e3f702c3528755c0880403e74ef08f0c48be7c4fbef972ea9cc18a" => :el_capitan
    sha256 "4ca805b1f1c88e8e62120cac73f9dd91cb8db83f8dfbbd6e53577565a804f918" => :yosemite
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
