class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://github.com/hypre-space/hypre/archive/v2.18.0.tar.gz"
  sha256 "62591ac69f9cc9728bd6d952b65bcadd2dfe52b521081612609804a413f49b07"
  head "https://github.com/hypre-space/hypre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "07de8ac34f7afb5fe97c41bb24ca73a6b385730a39e5bfe92718629897385a29" => :mojave
    sha256 "6213bb31523f76c05685fc48439db646cb78974b86b33e5e3184ca4cf626dd70" => :high_sierra
    sha256 "9e2e9aeb32961d9269ee363cf4c19bf973aefebe63e36c6665026df9e1826a4f" => :sierra
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
