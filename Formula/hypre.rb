class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/v2.26.0.tar.gz"
  sha256 "c214084bddc61a06f3758d82947f7f831e76d7e3edeac2c78bb82d597686e05d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb34dcf53251fd2ffe2a5918a575a378da809f0d2b00c4a2fc8ae254cd1d74db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ccc2b2ebe3c681ba0d9dba627d0f3136fc57fea98e161f3d592d409964a0146"
    sha256 cellar: :any_skip_relocation, monterey:       "bcc880194b5b725898e6fa4bfe2cf310df77a45110cba13a183fab383556a68b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4522eaf45a721751eae6bb6f2106e4c29cddf53e30f37a2521cb153e253a8788"
    sha256 cellar: :any_skip_relocation, catalina:       "79a65fde33f9ebd9922a89ffeca1726239c7d8fca806c18ac9ddfc08312fe1eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41190897eaf962f023b84a42ea52d82390ac84bd888cc92d9bd68bb580016f68"
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
