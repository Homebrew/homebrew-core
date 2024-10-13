class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "https://www.netlib.org/lapack/"
  url "https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "eac9570f8e0ad6f30ce4b963f4f033f0f643e7c3912fc9ee6cd99120675ad48b"
  # LAPACK is BSD-3-Clause-Open-MPI while LAPACKE is BSD-3-Clause
  license all_of: ["BSD-3-Clause-Open-MPI", "BSD-3-Clause"]
  head "https://github.com/Reference-LAPACK/lapack.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_sequoia:  "83296d714b2d6e36d217c846347b6a8379c7c98abf41c78e04c6ccbe92b10c8c"
    sha256                               arm64_sonoma:   "bd21dff4c9a6b02755665bdc65ecd552225765120f99ed23c07cd60661b40c91"
    sha256                               arm64_ventura:  "146f145ece5043bc57054f286a40938090fbcbc89b3dffe65156eec700eff66a"
    sha256                               arm64_monterey: "0ac519dd79d49605b701100b8efed28473ab306956ebc5b7bd2a6e0ce6414e88"
    sha256 cellar: :any,                 sonoma:         "bcb2bd2f402ea9a3c29e437379d6dda0388d965190c48e070ea9dbf366f5c1e9"
    sha256 cellar: :any,                 ventura:        "426f67c2f2a95e038fd99521d95805fb0fefc2e9ab7d29f14528ba8c9c751f2d"
    sha256 cellar: :any,                 monterey:       "832693c8606c45437f9a771ea206551a61bd76b0781901e0fc688f365b17abd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcae5519000d77385af41cd16e95af061f744bfd9fc794f9f3c2f4e87330f3ec"
  end

  keg_only :shadowed_by_macos, "macOS provides LAPACK in Accelerate.framework"

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  on_linux do
    keg_only "it conflicts with openblas"
  end

  def install
    ENV.delete("MACOSX_DEPLOYMENT_TARGET")

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS:BOOL=ON",
                    "-DLAPACKE:BOOL=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
