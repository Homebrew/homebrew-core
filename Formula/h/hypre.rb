class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "5273205a310fb6aa3ae506ce216760fb67b30e02024874f3cdb8b811e4801de7"
  license any_of: ["MIT", "Apache-2.0"]
  compatibility_version 1
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d9375b94f9772d532adeb1b42579d029637551398fec1ebaac315d0645225c78"
    sha256 cellar: :any, arm64_tahoe:       "7f984a7002537f3f400ba750129cdcf043ae625b2dabec88ae7ed47dd489415c"
    sha256 cellar: :any, arm64_sequoia:     "483fd6887392d95ba92c96a111d7a146cb6946b141c13674c39cc252a77267f3"
    sha256 cellar: :any, arm64_sonoma:      "13fc79b0abcbd023c811881f3a0cdf93fb5cfa535fb5b2e89d98c228c6471870"
    sha256 cellar: :any, sonoma:            "602deabd1ce19a42ebbb90e929377132c36952a75dcaeadbaf63206aa2207b7b"
    sha256 cellar: :any, arm64_linux:       "979f97ca9207cb9388c2f49b3452e205afae1d6f39b72c82adbc80cceab9e72b"
    sha256 cellar: :any, x86_64_linux:      "b97c5d3c68eb91205d4cd7ac65324ef020edcde64a2f92d2f199cf23db3b2cb0"
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
