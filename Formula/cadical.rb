class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "http://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.6.0.tar.gz"
  sha256 "104a271f7448827f5b48798e0b305b150631df6a6bca1106b3d2b4ea4044efab"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a04a1cf51d72b88fde89ae51d496636366170dfe9daa0387a2cc2ff2908212e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faccc9164d5cbf0cfaafdad822584e9164d9008d6e5c982f28b05c591a15221b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05c351ca904bd21985ab01e3f55840f5db6cc9901703abe7e6d667f3354ebabf"
    sha256 cellar: :any_skip_relocation, ventura:        "d08b02559bfa24a89cf4028f60375a6d4d77090838761ec5f2095ecc95eea6d0"
    sha256 cellar: :any_skip_relocation, monterey:       "fc16a5b7e7bb2ad1133a7157ad8a36928d1749abdcc5ac8cfa39c93e3aaa77b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "861545b554740c48b649cd65182bee101006068b23e4349bd12133d229cd9c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e427cf98a459ffee402ac737d8518f5514b5086c5f85301873df988d8f6110c1"
  end

  def install
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
