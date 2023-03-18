class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/v2.28.0.tar.gz"
  sha256 "2eea68740cdbc0b49a5e428f06ad7af861d1e169ce6a12d2cf0aa2fc28c4a2ae"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74f9b4b8ce24aedb564404240a7efe8f3509b784b0d2bc14aba26898d1480425"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aabe0c2cf20709c5c5278934555175cac9eda31cf03ea30f2c8c293043319f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1c2d4e41645f2631597ed8dc4217335e5acb1d0a08afcdba7bfd0cdc25f1d15"
    sha256 cellar: :any_skip_relocation, ventura:        "1989c81e59eb9cc05628145f0314f1bcdc6feab856df3cfbca3acaf6dda2025e"
    sha256 cellar: :any_skip_relocation, monterey:       "4f203d35da313a08738aa6b5573c5f93f17259003b13145f80df3e4216520f88"
    sha256 cellar: :any_skip_relocation, big_sur:        "844568347db32372c06ea535064ea632e1a7dce2bdff09ca7323e8a1884e57f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a139036821e611eff6a25092f36ef1bdeb3bde08e4a8388a255328503f66f0da"
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
