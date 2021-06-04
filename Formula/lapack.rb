class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "https://www.netlib.org/lapack/"
  url "https://github.com/Reference-LAPACK/lapack/archive/v3.9.1.tar.gz"
  sha256 "d0085d2caf997ff39299c05d4bacb6f3d27001d25a4cc613d48c1f352b73e7e0"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    sha256 arm64_big_sur: "b452053345423041c19f00b5146eef0d5e75d0482ab96895cadbc9cd80d03cb3"
    sha256 big_sur:       "898f178395b354f8450d31b5341da9d0e5b54078f39ce8567f7de6b5fe0f6082"
    sha256 catalina:      "682658f1f6b71fe3c3839da4319a378bcfa1865928e7490485542d2bb77f8e7a"
    sha256 mojave:        "4f827cef3e1782d497e0e78564dbee89b25c05c856e526f766c7051febbb093b"
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
