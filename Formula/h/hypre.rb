class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "d9dbfa34ebd07af1641f04b06338c7808b1f378e2d7d5d547514db9f11dffc26"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e63fd1cc1cb3ea9de65cf75be9f7b37e5fb83f940b5c1338c097deda0b84e93"
    sha256 cellar: :any,                 arm64_sequoia: "2361e794f4bb241e65415f19b9b0c95de56018c8daf5aa7bd2bdbea397aaedaa"
    sha256 cellar: :any,                 arm64_sonoma:  "77cb6097397709b6f8b0fe713c2ebfc513734c0c6d5fe99361e8c314f42bebd4"
    sha256 cellar: :any,                 sonoma:        "39d9063d7149e4afee2b9eb19021a0f6b0d9567634de8e837cf3498a90a8ab06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de5e8eaea0851519ffea47be23ef7f0d53bc928993845e1602db0d95c7efa10c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f12e2544f97757c210e3f6fbf136eec98ba2e33fb338922fbb3ccbab19debf47"
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
