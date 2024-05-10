class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "9a7916e2ac6615399de5010eb39c604417bb3ea3109ac90e199c5c63b0cb4334"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2ca7caa0247193fd7e8db5a532f8bc0b7a95ddcffd919608e82010ecb341c12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07762e61c472e7cd090987ba54b7c7a7c51ebcf0e3b73fb25f4e8baf8b90af1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb347369bb6d4f5b98db7f4b8aa670a219cbdea86984f24f2794dee9018b101a"
    sha256 cellar: :any_skip_relocation, sonoma:         "970c7d80bbf3b1266e3109c279775c8e7c6377f88a69236adf01e9bb3f941a8a"
    sha256 cellar: :any_skip_relocation, ventura:        "4fc865a9da72f13f6972418cb005960c9dd284acf624d3414854a81af10376ce"
    sha256 cellar: :any_skip_relocation, monterey:       "468fc9bf92081aa162b282c1b98b0c9481419f9318b9867248617eb2cb1524c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c253769438511500e428dc15f9f3b264a3dd743864c4771085a8f1c3b58b361a"
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
