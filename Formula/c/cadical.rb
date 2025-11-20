class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-2.2.0.tar.gz"
  sha256 "46694892c2d2ebc7a77cd33edb35c71c8bf92a5aae600f04fbb977b1c7824083"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34e909425f8e322ccc5641c1ed4883e1254ef777cb3362ade5061c27e5b1624d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86f5bf2db885bd6ee1a06b486b5f2b964f645135a89adf6385b7785d427ddc14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c923082672f958a4836b36bed59ef3c6a826dd4c09ef2f503ec5717a9c054349"
    sha256 cellar: :any_skip_relocation, sonoma:        "17552d341daf99a12db7c05c56e3791e984daf72dfe77c0ea0824f3381e5ca32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e1ebec3d75bfea835010d91acb424a62b40c537eac3d976ba56b9d07a112614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "396845e37e35efafe3320509a57f309d03b4702fe7068c62ec536020b35d30fe"
  end

  def install
    args = []
    args << "-fPIC" if OS.linux?

    system "./configure", *args
    chdir "build" do
      system "make"
      bin.install "cadical"
      lib.install "libcadical.a"
      include.install "../src/cadical.hpp"
      include.install "../src/ccadical.h"
      include.install "../src/ipasir.h"
    end
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cadical simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath/"test.cpp").write <<~CPP
      #include <cadical.hpp>
      #include <cassert>
      int main() {
        CaDiCaL::Solver solver;
        solver.add(1);
        solver.add(0);
        int res = solver.solve();
        assert(res == 10);
        res = solver.val(1);
        assert(res > 0);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcadical", "-o", "test", "-std=c++11"
    system "./test"
  end
end
