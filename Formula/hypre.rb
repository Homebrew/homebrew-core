class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://github.com/hypre-space/hypre/archive/v2.18.0.tar.gz"
  sha256 "62591ac69f9cc9728bd6d952b65bcadd2dfe52b521081612609804a413f49b07"
  head "https://github.com/hypre-space/hypre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6c976ea7fb7eaf275e2404e48f136d436c4e56a2fc0d49e4eb8db5b57708336" => :catalina
    sha256 "b8ba54670957d9253dcf2f34ba968cef71cab123bfa6dc20be7befac0db4abde" => :mojave
    sha256 "032e59eebde294d0222ea3ea619ce94af962d760eaa5bc2cf6d509e105012f17" => :high_sierra
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
