class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://github.com/hypre-space/hypre/archive/v2.18.2.tar.gz"
  sha256 "28007b5b584eaf9397f933032d8367788707a2d356d78e47b99e551ab10cc76a"
  head "https://github.com/hypre-space/hypre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6330b511b0e5a2ab686fd15b3de330ea9e104bab3fcb8f2ff1dc3c70b55b0a39" => :catalina
    sha256 "2d2b435909d08f1d1d59cc9c6a4c2d4ec6148f1422e8b11c93fc923785e7b84b" => :mojave
    sha256 "92ae0488c49e818175585a2975e9d5a055b0235839bf9bc2e102152d0a9c8168" => :high_sierra
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
