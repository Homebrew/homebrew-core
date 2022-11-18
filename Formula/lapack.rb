class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "https://www.netlib.org/lapack/"
  url "https://github.com/Reference-LAPACK/lapack/archive/v3.10.1.tar.gz"
  sha256 "cd005cd021f144d7d5f7f33c943942db9f03a28d110d6a3b80d718a295f7f714"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Reference-LAPACK/lapack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fd57c8d9c6a9a0b25bb04d03682cf90bc80b5bbe761bf8247b811aad30a8f5e0"
    sha256 cellar: :any,                 arm64_monterey: "09130dbc2603baca002e6ea6b2a5c004c365c20c6fe877189d7c3471a9a92ba3"
    sha256 cellar: :any,                 arm64_big_sur:  "e59a53da36ae4bb29bf38cac3c9bf09ce60360d4ad7d0db39e7d58e89edb3adb"
    sha256 cellar: :any,                 ventura:        "8b1f54b586daf612aed59a95eef0539ca6f9ab11d3e8ce1c6a20966eac4099d5"
    sha256 cellar: :any,                 monterey:       "19cf7e41a098fce0b0869fab10d0aba45fe84e091d082e76ac1446d3cffb53bf"
    sha256 cellar: :any,                 big_sur:        "cd447f7ca31dfb2fd2e8fbef983593c9d8ad8040b9629e5867103f5c28713604"
    sha256 cellar: :any,                 catalina:       "ebd9ec42cc08e6aec7ee743ef1f78b4b116d2291d4f35acce2d013d37e5c14c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e910a286f96f78bb20483d7d07c73307f71d093cbe1455e025de7eec653fccc6"
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
