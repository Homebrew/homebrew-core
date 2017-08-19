class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://computation.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods/download/hypre-2.11.2.tar.gz"
  sha256 "25b6c1226411593f71bb5cf3891431afaa8c3fd487bdfe4faeeb55c6fdfb269e"
  head "https://github.com/LLNL/hypre.git"

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
