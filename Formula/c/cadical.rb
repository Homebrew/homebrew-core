class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.8.0.tar.gz"
  sha256 "f053be060898079f353530b7d2fc25360f9b43ad924ae0891e13cc3193bf8ca0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f34dd3a09d93c05e17a4959d6f6e033e667ab9fc99a08e9f219dd3afdaf43ecb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34a51b6e03886469b018c35248879297631384b885c4b224c608e6248a2c64ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c24bd0c8b4f649a9dfaf61f2249eff8ecc15d6e5aa2128b1f0ff5a3d860f01e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fc102d9845dd2526549b33a8848b6b1615221902c0b49e7df6f743188f96090"
    sha256 cellar: :any_skip_relocation, ventura:        "25c06e8197d701ec753cd74e59efa7aa32e8e7eab4e62fdcc17c27b1ce5c198a"
    sha256 cellar: :any_skip_relocation, monterey:       "cfbaa067338341436ac1d26d31008e54139cfaea45b357aa0a5ab65c1d3e252a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1e37bbe9de502c08aa79b5a0b6f2e66e0f748ddf236014f6066ac47615a0398"
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
