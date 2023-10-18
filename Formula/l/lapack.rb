class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "https://www.netlib.org/lapack/"
  url "https://github.com/Reference-LAPACK/lapack/archive/v3.11.tar.gz"
  sha256 "5a5b3bac27709d8c66286b7a0d1d7bf2d7170ec189a1a756fdf812c97aa7fd10"
  license "BSD-3-Clause"
  head "https://github.com/Reference-LAPACK/lapack.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "939edf8fa10adf5140f91e6208a23a6466ea113d94eb4cec666dc3128ecf66bc"
    sha256 cellar: :any,                 arm64_ventura:  "f70b3ce19cf4a9fb328f71caba7b40bacbddda80e9ad196401bcb3e0cd9e4ad7"
    sha256 cellar: :any,                 arm64_monterey: "c9e7171ba3cc0159086737a3905e7403c81bcd3ad6cc506e955e00ac730eb302"
    sha256 cellar: :any,                 arm64_big_sur:  "c814d96489b94449715fdab61925f859092e7d4103ec35d42bf46652628e9a52"
    sha256 cellar: :any,                 sonoma:         "bad04b8e7d6f291c1c7d68d916b73aeb5b294963a15ba4524f444015b0a47054"
    sha256 cellar: :any,                 ventura:        "7f59f3c3bb3d76b6f44d28bfb0abc7c13970c473b5f53f810acd58060c6a71df"
    sha256 cellar: :any,                 monterey:       "f0ac2a70102bc54a9f617678161653d7d261966b6a9ec68d22a805f0d3f66658"
    sha256 cellar: :any,                 big_sur:        "a98f6ed1c5cba50e0887b9599da3c881e83198965afd471f9532effd0dc9491a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39ebab237ba84c5ba207b2d31e84e75e901bffb769e8ee7680060e9ba36c2ed0"
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
