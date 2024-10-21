class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-2.1.0.tar.gz"
  sha256 "0652b2b3f2dbaf19f1940cd882823bce44b6fc7a3c025066da7932254bcee237"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b4f62ee1b2857ccdb09afdbbf8c418b5967fce5b5ffbe0ffa854f1bd31c702c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a867214a0efef9cf1473577fdf083e7459571291c46fbc14ebebb7dbec5da9c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c49ba30b47bbe27ae07a91bb6d449c0aceaad2092f5fddfa49179134d015b9ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "87d2b945a9d51d024e6ce68ff13f15d91b7044509712a21e2e145aae1f904ebb"
    sha256 cellar: :any_skip_relocation, ventura:       "be13804c8da4cbe8f13dc6e48094f84189fc633ca692e0710b1f3cdecdc244fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf7fb63d8bc84ce56d068081b801fa85385a4d4c8ec3d3b2765c3ab535d71fdb"
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
