class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/v2.24.0.tar.gz"
  sha256 "f480e61fc25bf533fc201fdf79ec440be79bb8117650627d1f25151e8be2fdb5"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44841af9c7111e9fd3007b32f8213eba3c7ed28777fc1f70de8b7b0bba6a2b1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3d9f24e95310911ecddc9a02fa429777ad3a5e83807a8d4f3ee75c201e2ceb5"
    sha256 cellar: :any_skip_relocation, monterey:       "dcf7562ede14cb94927422dd4bba1825aa418c337b7488e851cfb023a247f74d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b8326ebfb34e322783d5141adb43da61c57b4cf0e5b1c56ee644f1a32881e59"
    sha256 cellar: :any_skip_relocation, catalina:       "99c8fd673cd2e5bbc82a2fd89fc8a70633d71c1c4b48fa423633fb55becd336e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39296dce672a6354345bd655090974b0208e5d7e1d8cbb1b87afe32660345b2a"
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
