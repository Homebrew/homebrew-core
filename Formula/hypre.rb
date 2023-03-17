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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6fc7983ef7856a66ce2f918624f271717beb27e63db86942e6b6f1b1d4c7cf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "391465307d0b80730edb73313c16727560ed179abc68199da28fba2bd50d9c94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2421848fcc0982cde3081d2416317877975a336b755bcc215943b28bafb260a"
    sha256 cellar: :any_skip_relocation, ventura:        "327c45c4eca604c333f6be802f7455f83a146a00954a326e659670bd0505768c"
    sha256 cellar: :any_skip_relocation, monterey:       "d61aa53e53ac0dd38fbb7fc3fd68b98a7d36f99447a2646a587c03c6a075aa83"
    sha256 cellar: :any_skip_relocation, big_sur:        "a22dfe4d9c409401c8ea1503fa0f5e91a9a95b13ee0d8b0876ab2354bb858cd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2999be3899011969e428b548f39451762d56551f20dc933cf18eaec45c82c132"
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
