class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "https://www.netlib.org/lapack/"
  url "https://github.com/Reference-LAPACK/lapack/archive/v3.9.0.tar.gz"
  sha256 "106087f1bb5f46afdfba7f569d0cbe23dacb9a07cd24733765a0e89dbe1ad573"
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    sha256 "c5f8a726a57ffe294cfc488752ed2ad9f15e76ab211be020834df4f196b81b59" => :catalina
    sha256 "47760f1eba02ad2c66f536acfff97e4bafaff4c6088822c8547f7df35a92fb33" => :mojave
    sha256 "25833d6cbc3e54bb2c055727865ddd3ab74ffb53bf5a7fb285e73f9f5737ad05" => :high_sierra
  end

  keg_only :provided_by_macos

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
