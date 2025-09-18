class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "0f9103c34bce7a5dcbdb79a502720fc8aab4db9fd0146e0791cde7ec878f27da"
  license any_of: ["MIT", "Apache-2.0"]
  revision 1
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "611f26f8b27465513001a968d557b00fbd50c8a0c08d35b47f3673b5540da7d1"
    sha256 cellar: :any,                 arm64_sequoia: "beb3d2c609d542c1a74709ac01faffc25148b0e052a617342bca693b18241823"
    sha256 cellar: :any,                 arm64_sonoma:  "03aaacdf60bc773d746538b5e6bc5815481af39d8dbe2b554e75d6f5f32424a2"
    sha256 cellar: :any,                 arm64_ventura: "324360d183876464b8ccf254e668820d0287b29cfaabcfabc2b228402d9fdbd0"
    sha256 cellar: :any,                 sonoma:        "dc6ed08e556be37a1f34b5b557e949228826b857a6c29de98fdd4176a5599262"
    sha256 cellar: :any,                 ventura:       "e7931d4b3a96f1020dd44551449dbc89fa27476cface7366385a1f17e4b4783f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c37c9517a610c9051d5fc5ea268945c2214b06fbf81aa2b51167dd909052bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7381b210318269b8894f650e2b682fe9bf8751628022553104e3f25d5d3502cb"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"
  depends_on "openblas"

  def install
    system "cmake", "-S", "src", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DHYPRE_ENABLE_BIGINT=ON",
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
