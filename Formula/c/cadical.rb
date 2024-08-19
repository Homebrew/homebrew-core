class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-2.0.0.tar.gz"
  sha256 "9afe5f6439442d854e56fc1fac3244ce241dbb490735939def8fd03584f89331"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9825a0c9c4c024f5023494de2712b28b28deab1d7cca9aa1033cf5f89d9345b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff3003444ea747f336347ffcc6a8d6814b5456f52e7604255db0844f48891551"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4785bb323b72519598901d2423da7c70d9d975f9588c79ca7d15cf298851286"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd0d8346c3c1baa30a5e0a8ca3a43be9e15233baf2b687a53259c35843280233"
    sha256 cellar: :any_skip_relocation, ventura:        "21d53219f41b054fe86e9620f2d32a2705b22ea44e18b78bb4a3f636f7f6984c"
    sha256 cellar: :any_skip_relocation, monterey:       "818b56977e0184acb239948980be236ff7c27ad091473543ff6be1b5a6889abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f61dfbc010d7b4c25e835c9e3e102387774fa9ee820d3ae6356a91f12f0fc73d"
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
