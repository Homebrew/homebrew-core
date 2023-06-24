class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/v2.29.0.tar.gz"
  sha256 "98b72115407a0e24dbaac70eccae0da3465f8f999318b2c9241631133f42d511"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57781669b62d7eb3e34d60d8e09d8c31b11d4fdd52023a8458b3826042eba12a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96bbca9bfea390f76c8f80cb3ae2edd6a31836591951471fd281f11ce866537e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a411682ec9ee101422be8c79061a2c6aea9e623b69356e762039b0885faaec7c"
    sha256 cellar: :any_skip_relocation, ventura:        "d0944001c48e56187972ca23b7b473b2f426acb7155812968ccdc64145ac0599"
    sha256 cellar: :any_skip_relocation, monterey:       "8ec43a3621242e4ca2b53c4f66b41e2077e60ad28c749dae3e28eb8954280e86"
    sha256 cellar: :any_skip_relocation, big_sur:        "d748f75570c4e130969b8f49910ce557eb938f9e5790bf25367e7024f99b8472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e35eb8e4e9a9dd19fd48d36fcb5a9192e79fff31657399dbad9ec5236576ea15"
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
