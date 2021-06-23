class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/v2.22.0.tar.gz"
  sha256 "2c786eb5d3e722d8d7b40254f138bef4565b2d4724041e56a8fa073bda5cfbb5"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8028db25d1814a982533c6783d0b0fa3ea23405d2fefb9d52bdb128db5d9aae5"
    sha256 cellar: :any_skip_relocation, big_sur:       "ddc639498b314c72bbbc2ac61ccd7867c18544eb02188d45008a44a3815a4ee9"
    sha256 cellar: :any_skip_relocation, catalina:      "fe07da5e7a7d25ff95c202743b647fed56fe3b9c88f44688c714dca8ea43c68f"
    sha256 cellar: :any_skip_relocation, mojave:        "bd7f4929f31e0f01868989770ebdb93f8d6487e0c22215781f9a8729aa84ad06"
  end

  depends_on "gcc" # for gfortran
  depends_on "open-mpi"

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}",
                            "--with-MPI",
                            "--enable-bigint"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "HYPRE_struct_ls.h"
      int main(int argc, char* argv[]) {
        HYPRE_StructGrid grid;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test"
    system "./test"
  end
end
