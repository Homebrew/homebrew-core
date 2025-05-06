class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "0f9103c34bce7a5dcbdb79a502720fc8aab4db9fd0146e0791cde7ec878f27da"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86c808a2d91ad2cb4e451e10445911ebdfddc094f683ec5dc4135e3d32373179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "980dfd622aec636d422f3ee28ca6a0a8069634b85c75f45bd0a61136ed241dd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd5cce6bbe748ee40110a0c6fa3be575a7ad940435c162194cc6504f300cdc15"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4c4a4b58c7b5217f625d1e0726b899563f99a3d92a45decf651522900fc2ef9"
    sha256 cellar: :any_skip_relocation, ventura:       "b62f0376fa5930164977c6b3e5766ecc14375a5f7e15a806c28fbf2ce241dcee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f890413fed72b117977cd0235e885a983af1fc5c998a98fa22a7aae87333a596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9eea76ecc19f0455d9a8416aa615626f67c77d6792ae173b1d6944ceecb1c2c3"
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
