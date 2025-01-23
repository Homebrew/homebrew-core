class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "2277b6f01de4a7d0b01cfe12615255d9640eaa02268565a7ce1a769beab25fa1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bb569f455b6a558e1560208f709c4339b2e735730bb207b5aeb1664d6da7f0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cc61d2ca6a31921d675b0fffa2e6b52a6b968342928cf4af5b288730640499f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad27f8eecedf4fb1147eb571f2937e04be18a51cdd121e04428b0d9b61ffa8cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "74ce43873f22dcf17713fdbfa2fde36623b78c58000a1cee1d25026576a4320c"
    sha256 cellar: :any_skip_relocation, ventura:       "ca7593f855ad9e3a934352eb3531d14402dcd48493bbc780c2cff79f2fc14617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3acee0b6a075972c6b1350fe5a935b904ed4c1fa8906f81a767b1bcb4f3cf0b"
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
    (testpath/"test.cpp").write <<~CPP
      #include "HYPRE_struct_ls.h"
      int main(int argc, char* argv[]) {
        HYPRE_StructGrid grid;
      }
    CPP

    system ENV.cxx, "test.cpp", "-o", "test"
    system "./test"
  end
end
