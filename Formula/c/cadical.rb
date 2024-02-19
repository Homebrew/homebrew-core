class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.9.4.tar.gz"
  sha256 "39b16f6909adbecbe03ea1e170fc51c976135ce63d159e32706162e4eff7c4f8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "531039129b71895c06d6c4cb9710ddec426a1b58c9d2bdde1fed8e58d3db8c93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47ce132cd04bf93473759d84712a390c3019332021d3fa786f39e02f6c5bbc84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba96834d0685697f44054206bac328f4655cf59e062f0516484b0f93090f72f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cc90d700f35537520f8974e572b206d80959af7c9bb25c6fdf873ec9b3005a1"
    sha256 cellar: :any_skip_relocation, ventura:        "c03edc463190a12d60f730c35c73f1f1317f15dae116959b0548621b5c6ce526"
    sha256 cellar: :any_skip_relocation, monterey:       "8156675a7ebfba7ee149cf10c1e111ec6738a34803295dc94b6368a29e570e20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da8e84424cb812c9e6b64c3998bfed60766e980c1e24aee0813d15cb558bcdb5"
  end

  def install
    ENV.append_to_cflags "-fPIC" if OS.linux?

    system "./configure"
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

    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcadical", "-o", "test", "-std=c++11"
    system "./test"
  end
end
