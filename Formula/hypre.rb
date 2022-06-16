class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/v2.25.0.tar.gz"
  sha256 "f9fc8371d91239fca694284dab17175bfda3821d7b7a871fd2e8f9d5930f303c"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f4cd25371d2dc068d39fe6f39c5b4cacb692edf75092eb2c47891b5fb2bda4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6550e352150a1de8dd5f4f903c7b2056b8039c13c6893e8617b468914d4bcaad"
    sha256 cellar: :any_skip_relocation, monterey:       "1d07af933366c802f9ffc4460d8c6ca5f1b6c50afc204a4b35bb410c7332be6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "793d38b3715078633764087ab93ce21144705fbaee77d142874e9d70f235e935"
    sha256 cellar: :any_skip_relocation, catalina:       "c162dcb73bb748a8568e3f521e79e201dc28cb20ea856407b24e61f040d8a5d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "797922e90e36ca44e337072bddd2276461bdc8b6be687eed37a4dc0f8947d8f4"
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
