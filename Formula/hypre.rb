class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://computation.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods/download/hypre-2.11.2.tar.gz"
  sha256 "25b6c1226411593f71bb5cf3891431afaa8c3fd487bdfe4faeeb55c6fdfb269e"
  revision 2
  head "https://github.com/LLNL/hypre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0d1c37af0624bd9c7638bd1288c9cc523160ceabeecceb7534bed6bdf0248df" => :high_sierra
    sha256 "bc90328c270fde57f6c1966ef076f095455d5297c4a996db79f44cd4e7258e11" => :sierra
    sha256 "302d24880cb100ea35d51961c01992fb4acc151f88a760703443928c5739ea9f" => :el_capitan
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
