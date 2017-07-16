class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "http://www.netlib.org/lapack/"
  url "http://www.netlib.org/lapack/lapack-3.7.1.tgz"
  sha256 "f6c53fd9f56932f3ddb3d5e24c1c07e4cd9b3b08e7f89de9c867125eecc9a1c8"
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    sha256 "41d1bb9c224f0248680549d3c5a6a100d72182ca5a686c0bf93d8fd3a9161d13" => :sierra
    sha256 "3e31bb5858b3338834d3a69a087db8f7ec15f52a6b222f2aea4c6eb9e649b095" => :el_capitan
    sha256 "fb6b1e6cb50b3b1d1b4bb85c6b6e0393e3fadba89fc42e7aa593e6a649f4bf0e" => :yosemite
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
