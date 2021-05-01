class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "https://www.netlib.org/lapack/"
  url "https://github.com/Reference-LAPACK/lapack/archive/v3.9.1.tar.gz"
  sha256 "d0085d2caf997ff39299c05d4bacb6f3d27001d25a4cc613d48c1f352b73e7e0"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    sha256 arm64_big_sur: "d9cb8ec5b3323036392af942ca33f408648fd8c08965653a599d918f5f2790a7"
    sha256 big_sur:       "b030a88ee8fa327ecdd5b33ba31a5ceaf5137e5f6c1ebb861911cca6d5bd23f3"
    sha256 catalina:      "6c5f2f1fd02df12472fa05eb39dd7bfd0c8f1a7e367afebef9848c2c4503a97b"
    sha256 mojave:        "6d637980e356e094bb6f35bc171cdac72ef73d94fe3dc50d3a6ecc1af7eb14a2"
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
