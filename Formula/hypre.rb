class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://computation.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods/download/hypre-2.11.2.tar.gz"
  sha256 "25b6c1226411593f71bb5cf3891431afaa8c3fd487bdfe4faeeb55c6fdfb269e"
  head "https://github.com/LLNL/hypre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "541fcb1adc778e587e3f8993bdf7d6c7fabf026ed2256af0e8a4fc64d831f9ec" => :sierra
    sha256 "a610e8ee47f8962ff959e8223d44f87320303144690458550264bceb016464cc" => :el_capitan
    sha256 "e228abcdbeeed01a30b13f1471cb848d309fc306a861d745338b71451374e032" => :yosemite
  end

  depends_on "veclibfort"
  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f90, :f77]

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
