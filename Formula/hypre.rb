class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://github.com/hypre-space/hypre/archive/v2.20.0.tar.gz"
  sha256 "5be77b28ddf945c92cde4b52a272d16fb5e9a7dc05e714fc5765948cba802c01"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5f2247c3fee3495c13111221ed6eb37b7b154ae40a301aded68028cf767ec757" => :big_sur
    sha256 "ddd013fddcdc9ecd901dabe5ac558a457152e661e1f4a20310d24609be07d667" => :arm64_big_sur
    sha256 "9d732247f823113d50fd5d5e144541ad92dfab1f8df05298426bea24743e693b" => :catalina
    sha256 "ecba86de35962ede83358e77986f65ac66e3632c8b255b91fde2b986c10d8c80" => :mojave
    sha256 "0c88309a25471939828ac8e9f8851b0a83bb9b2a11103837a12291a59351a520" => :high_sierra
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

    system ENV.cc, "test.cpp", "-o", "test"
    system "./test"
  end
end
