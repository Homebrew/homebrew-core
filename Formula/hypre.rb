class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://github.com/hypre-space/hypre/archive/v2.16.0.tar.gz"
  sha256 "33f8a27041e697343b820d0426e74694670f955e21bbf3fcb07ee95b22c59e90"
  head "https://github.com/hypre-space/hypre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7300641b6af625482d20ce1b0689c3bb62994ba2af30c92fca68271a8ebaf92" => :mojave
    sha256 "cef93684119abac2fbd535ed125779877639e26b7e0304258d285ee39bbfb992" => :high_sierra
    sha256 "0ffe333f6b327977d2c91b192d31b0483b7d0fd7f8b08112874a853f8e591271" => :sierra
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
    (testpath/"test.cpp").write <<~EOS
      #include "HYPRE_struct_ls.h"
      int main(int argc, char* argv[]) {
        HYPRE_StructGrid grid;
      }
    EOS

    system ENV.cc, "test.cpp", "-o", "test"
    system "./test"
  end
end
