class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "https://www.netlib.org/lapack/"
  url "https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.12.1.tar.gz"
  sha256 "2ca6407a001a474d4d4d35f3a61550156050c48016d949f0da0529c0aa052422"
  # LAPACK is BSD-3-Clause-Open-MPI while LAPACKE is BSD-3-Clause
  license all_of: ["BSD-3-Clause-Open-MPI", "BSD-3-Clause"]
  head "https://github.com/Reference-LAPACK/lapack.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "fa38687518be4c52b96c7b0f6329c0b608398c980f71e381723101e22d99d6b3"
    sha256                               arm64_sequoia: "b28ffd5a179cb39c06903720a05f76129b23d7269c6d7ab1c32d80e73dbc3549"
    sha256                               arm64_sonoma:  "ca2ffc67818891b7dd4fca4063b12582e4fd5d1c547a298e52d94ee0ae45da5d"
    sha256                               arm64_ventura: "fe4b0a8f8d36fe2351183e4760e1b79e60e4acabf6820bdd56b42a3fe64d55d1"
    sha256 cellar: :any,                 sonoma:        "ca9ab67cbfe96618babf11e67e0471c710cd7a3bb1f2f94aa6dcd5252e2a477e"
    sha256 cellar: :any,                 ventura:       "7d8b411cb368aaf73b9d16b83e5293aec80dd86a53696d35a8336ec013688369"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "733c1a52d5e40d17d54d87706534e013f5fb5505a52194b3d792ea13d7b0423f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a687f1b7990d523993bc1e4ee24c025206c11b9995f9172128142e98a6fc147"
  end

  keg_only :shadowed_by_macos, "macOS provides LAPACK in Accelerate.framework"

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  on_linux do
    keg_only "it conflicts with openblas"
  end

  def install
    ENV.delete("MACOSX_DEPLOYMENT_TARGET")

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DLAPACKE=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"lp.c").write <<~C
      #include "lapacke.h"
      int main() {
        void *p = LAPACKE_malloc(sizeof(char)*100);
        if (p) {
          LAPACKE_free(p);
        }
        return 0;
      }
    C
    system ENV.cc, "lp.c", "-I#{include}", "-L#{lib}", "-llapacke", "-o", "lp"
    system "./lp"
  end
end
