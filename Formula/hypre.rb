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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d8efc39a64885386f230bb87dee3f21fb01066ea6435e3e26df806e170c4f40e"
    sha256 cellar: :any_skip_relocation, big_sur:       "279ec7e7f7d7cb9f35726400670bf712fdcb4ff90b41ed8fa3f6b6044825385f"
    sha256 cellar: :any_skip_relocation, catalina:      "aea86f07dd1a186e92cb3bab3724da406ddd9fb52296e5c0c3e00325ffefc8fb"
    sha256 cellar: :any_skip_relocation, mojave:        "6e1d4bca68208860dcaec185ca1a1fcf90ef97e1ea7918868d6d7152833c147d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14347d2805d8c264f0059a9d1da1c560a148380e0dcadc1da72c9438cdbedd29"
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
