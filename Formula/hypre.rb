class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/v2.22.1.tar.gz"
  sha256 "c1e7761b907c2ee0098091b69797e9be977bff8b7fd0479dc20cad42f45c4084"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9b881406c5ac834e5a76b3d551f678a5321b992d275f311c1351b1cdb33471e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "bff460cccfead851b5abb304aca2f0ad15b7da66053a3d489c38b6960d0e7980"
    sha256 cellar: :any_skip_relocation, catalina:      "b9b84fa1ff57865583aca8e025664c1b3f9f18af8c6db8de285bdffaec402e49"
    sha256 cellar: :any_skip_relocation, mojave:        "b3af9969617a61e65607bbbbe7f67c16af7e3f95321060ad686ca1020ed2d3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19c15f04e0d243c8d9b16be49a4454ada29c3efe07847ad8070bafcf6c12e3aa"
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
