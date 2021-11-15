class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/v2.23.0.tar.gz"
  sha256 "8a9f9fb6f65531b77e4c319bf35bfc9d34bf529c36afe08837f56b635ac052e2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6d796ac1e31fcff5d06bbd3e09ab2646f7dfaa4f49ef35e8a09e1df6147bf57f"
    sha256 cellar: :any_skip_relocation, monterey:      "f12a1f18105429672ee561b804606545a1c9d7fd50d503f612710ec4f620451b"
    sha256 cellar: :any_skip_relocation, big_sur:       "2bbab9c35697fa612704afb0029668a41f57efab62c9729e6adea8283c393737"
    sha256 cellar: :any_skip_relocation, catalina:      "f2ee0a12ab45e114c9f88584d79048f9181ede8ec55a99b470f26621085818f0"
    sha256 cellar: :any_skip_relocation, mojave:        "c8da05950a2acde7622d24e878629c69618e1dc4882a9e02e76ee2f3427d98de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d8de40631ed84d03ca5267f71f22ae75704400b771f58296d30dbc026295550"
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
