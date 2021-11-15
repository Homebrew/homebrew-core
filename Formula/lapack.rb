class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "https://www.netlib.org/lapack/"
  url "https://github.com/Reference-LAPACK/lapack/archive/v3.10.0.tar.gz"
  sha256 "328c1bea493a32cac5257d84157dc686cc3ab0b004e2bea22044e0a59f6f8a19"
  license "BSD-3-Clause"
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "57b25ebfd66edca32e16acf1f7127af22bb1ea43a1f7b758895789696fe0590e"
    sha256 cellar: :any,                 monterey:      "ce6223d15a12cf1535460a3a6a59cd822ed5f44ca417f94a5bf29ed46931897e"
    sha256 cellar: :any,                 big_sur:       "3b57e303806b0fa8cb17738b10b3bd2b4801ef898fc5433af05b90cab9dddf40"
    sha256 cellar: :any,                 catalina:      "cbdfdaa3de046ff377bf0e6a974541016a0790c0ddba295eecdb4615f8ec5923"
    sha256 cellar: :any,                 mojave:        "619839fc1623b36c0b7bf8903e424c003bbd6ef96a0f9f7ed1ff684f231c54ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f1c1dcfcf68dd35f484bba3c43c7e070dcd4da9a03fad5c50a408a00d26e217"
  end

  keg_only :shadowed_by_macos, "macOS provides LAPACK in Accelerate.framework"

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  on_linux do
    keg_only "it conflicts with openblas"
  end

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
