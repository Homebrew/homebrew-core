class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://github.com/hypre-space/hypre/archive/v2.17.0.tar.gz"
  sha256 "4674f938743aa29eb4d775211b13b089b9de84bfe5e9ea00c7d8782ed84a46d7"
  head "https://github.com/hypre-space/hypre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a045ebcd19a075f7f35768bfbaef878eb59c5f76d8766e22fe360b78fd1fc0e0" => :mojave
    sha256 "065206800d3a8e5d9076fc01c4682779da2019fd8346509ed9ea366d37e58d4c" => :high_sierra
    sha256 "3daf19048b9f85a5f1547f473bed7c3c2f995fca683ad3234f2ee55d6e28df5f" => :sierra
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

    system ENV.cc, "test.cpp", "-o", "test"
    system "./test"
  end
end
