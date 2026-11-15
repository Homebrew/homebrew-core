class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "3083cf943e1dab54517acae36afad72a4ada2c72c9567e525fc9c6efedb14e0c"
  license any_of: ["MIT", "Apache-2.0"]
  compatibility_version 1
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "76e8fd2f733ce721de8616e1cf5eaec26bde3b668ca86024f950c6552ada6fac"
    sha256 cellar: :any, arm64_tahoe:       "01e274188942d63d53f324e7729304d324867153608148f3d2191ef26261697e"
    sha256 cellar: :any, arm64_sequoia:     "213c6d80f3a6fac2a3aabc13f35627dac04ca23be1621017c450cfbc2065a003"
    sha256 cellar: :any, arm64_linux:       "bfea71969d4037f24d91fb74b32b07c7fea8f15cc2ae704ed6c2dfa9212b0a78"
    sha256 cellar: :any, x86_64_linux:      "7649e1b89deb34720b5197e36fadcc876a1bc54a70b8e764b4c7eafe7e015903"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"
  depends_on "openblas"

  def install
    system "cmake", "-S", "src", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DHYPRE_ENABLE_MIXEDINT=ON",
                    "-DHYPRE_ENABLE_HYPRE_BLAS=OFF",
                    "-DHYPRE_ENABLE_HYPRE_LAPACK=OFF",
                    "-DHYPRE_ENABLE_MPI=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "HYPRE_struct_ls.h"
      int main(int argc, char* argv[]) {
        HYPRE_StructGrid grid;
      }
    CPP

    system ENV.cxx, "test.cpp", "-o", "test"
    system "./test"
  end
end
