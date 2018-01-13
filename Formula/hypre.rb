class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://computation.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods/download/hypre-2.11.2.tar.gz"
  sha256 "25b6c1226411593f71bb5cf3891431afaa8c3fd487bdfe4faeeb55c6fdfb269e"
  revision 2
  head "https://github.com/LLNL/hypre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8ae3742bdd41548c214a8ac0a4f139b31beb08d7d2cdffd018fff1875a631ca" => :high_sierra
    sha256 "a696ab2a3732c1b9970a9a09385e9577aede6131f1848b81abdde487139424bb" => :sierra
    sha256 "1b8117394f6f92485112b50678d82360766739bac5f1dc46d7573bfa97232138" => :el_capitan
  end

  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "veclibfort"

  def install
    cd "src" do
      ENV["CC"] = ENV["MPICC"]
      ENV["CXX"] = ENV["MPICXX"]

      system "./configure", "--prefix=#{prefix}",
                            "--with-blas=yes",
                            "--with-blas-libs=blas cblas",
                            "--with-blas-lib-dirs=/usr/lib",
                            "--with-lapack=yes",
                            "--with-lapack-libs=lapack clapack f77lapack",
                            "--with-lapack-lib-dirs=/usr/lib",
                            "--with-MPI",
                            "--enable-bigint"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include "HYPRE_struct_ls.h"
      int main(int argc, char* argv[]) {
        HYPRE_StructGrid grid;
      }
    EOS

    system ENV.cc, "test.cpp", "-o", "test"
    system "./test"
  end
end
