class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "http://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.5.2.tar.gz"
  sha256 "4a4251bf0191677ca8cda275cb7bf5e0cf074ae0056819642d5a7e5c1a952e6e"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fba92fd3b9fd396ef6af40f719f5f65e00af68f1689fc5d148f2e0372d52c0fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc60f414d905e5ee39f875b62737bfd20efc49167f82c0f843482266e9c61687"
    sha256 cellar: :any_skip_relocation, monterey:       "e5c1c3c8005992e5417c44d7336a0897fd95f1063403112020368869ac8aa987"
    sha256 cellar: :any_skip_relocation, big_sur:        "131d790150f919a92dae5c03146329d5b817cbac67c1fba45d5429d8dae085eb"
    sha256 cellar: :any_skip_relocation, catalina:       "b8f42f3bc6f87b5f83afb425a1b404d489d35f52c55e68925b2d4398e5e3be94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "649f8f12906a0c307cebfd28cd1a107eca9901638ad3ca0999789827f83550da"
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
