class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "https://www.netlib.org/lapack/"
  url "https://github.com/Reference-LAPACK/lapack/archive/v3.9.0.tar.gz"
  sha256 "106087f1bb5f46afdfba7f569d0cbe23dacb9a07cd24733765a0e89dbe1ad573"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    sha256 "be00d33447ab0bb47a05f89517640c984cafb7723fd6fff9749de773c304f2df" => :catalina
    sha256 "ad84de82af78dc5ee4b305c76a79a3fc18420beeac2be72d1c262936d5a9110e" => :mojave
    sha256 "fd360d9073e8a483e88a0bca6c8dc96a8159488fa3a6009bb8cbe03747f20f4f" => :high_sierra
  end

  keg_only :shadowed_by_macos, "macOS provides LAPACK in Accelerate.framework"

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  def install
    ENV.delete("MACOSX_DEPLOYMENT_TARGET")

    mkdir "build" do
      system "cmake", "..",
                      "-DBUILD_SHARED_LIBS:BOOL=ON",
                      "-DLAPACKE:BOOL=ON",
                      *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"lp.c").write <<~EOS
      #include "lapacke.h"
      int main() {
        void *p = LAPACKE_malloc(sizeof(char)*100);
        if (p) {
          LAPACKE_free(p);
        }
        return 0;
      }
    EOS
    system ENV.cc, "lp.c", "-I#{include}", "-L#{lib}", "-llapacke", "-o", "lp"
    system "./lp"
  end
end
