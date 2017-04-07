class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "http://www.netlib.org/lapack/"
  url "http://www.netlib.org/lapack/lapack-3.7.0.tgz"
  sha256 "ed967e4307e986474ab02eb810eed1d1adc73f5e1e3bc78fb009f6fe766db3be"
  revision 1
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    sha256 "f2afbb9b25d42a4c4ca3b4ea7995a98397f0cd69a878128d30ee0eb02d3c0e44" => :sierra
    sha256 "f8fade438f429b1e79eaf7329177996f009c10932ea6cdcde327fd5e7971c09b" => :el_capitan
    sha256 "b687da11ee0b742ed426aad8e39f1c0c84301af664e951ad308fcccdc377ea29" => :yosemite
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

      %W[#{lib}/libblas.dylib #{lib}/liblapack.dylib #{lib}/liblapacke.dylib
         #{lib}/libtmglib.dylib].each do |f|
        macho = MachO.open(f)
        macho.change_dylib_id(macho.dylib_id.sub("@rpath", lib.to_s))
        macho.linked_dylibs.each do |dylib|
          if dylib.include?("@rpath")
            macho.change_dylib(dylib, dylib.sub("@rpath", lib.to_s))
          end
        end
        macho.write!
      end
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
