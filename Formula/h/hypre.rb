class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "a6879ae9375d95c26afd97141d61e7a8092807333bf40cd180b385aed7351b2d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca82286770d54d33ffbbec6ae9da8087dc0fb72dab3c45980ccab7049983377e"
    sha256 cellar: :any,                 arm64_sequoia: "4c7a60d7b6a506032ee9e252462a53bce6d4b14275c3e2b9254a2b0adb607394"
    sha256 cellar: :any,                 arm64_sonoma:  "b5155a9395fa2aac62f082be1432fb69eb219be1c461829797c680e53b796601"
    sha256 cellar: :any,                 sonoma:        "cc4e2dd22e0d13c072a3df29f13f33fa787a9263f070eeb447afb299b9303051"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71bb3b3e680b427a8a804f6c0d87213842f0f2f170eeed3e951fc69cd61a5781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e08f288f4966b90af4fbb59000535df8f27e72b8a44831c0d20a027d7b75f20f"
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
