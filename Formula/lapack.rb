class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "https://www.netlib.org/lapack/"
  url "https://github.com/Reference-LAPACK/lapack/archive/v3.10.1.tar.gz"
  sha256 "cd005cd021f144d7d5f7f33c943942db9f03a28d110d6a3b80d718a295f7f714"
  license "BSD-3-Clause"
  head "https://github.com/Reference-LAPACK/lapack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2ac159c2ea5c7e054bdae3840a705547a0ea237aa2c76bc9f94a12e0ebabb976"
    sha256 cellar: :any,                 arm64_big_sur:  "fcba5f25c5029a0420e2e1c0f8add039ebf3459f654a0e5589daa2fa7d8450ba"
    sha256 cellar: :any,                 monterey:       "d075eb80d251d68555565163751f5d316750ad6934f680e694b928484ddbfc46"
    sha256 cellar: :any,                 big_sur:        "7113a5d7faf1138adfc5a7335d0ed8fa32c693fd5ce98c2475997370b65757d9"
    sha256 cellar: :any,                 catalina:       "6c16828729218498d4d547e3c7123b11770e15bf8c2bff1eefc7ffef5895ec29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee6d1e0c63ebe081342634dbc7d540ef6ddc3b2f2713680f564eae357750458c"
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
