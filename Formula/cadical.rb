class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "http://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.5.3.tar.gz"
  sha256 "0ff521ed36d57478a8dbc610e0d27536c9d3a2154d859152f33f8733a6dca31e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54b503c5e0b699a0b4e6a1b2bae4f4e84cd5c41fd0146dea815640c2d8c4ddbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec9e2713567e9f62cd478b9c96607fe7d032f3aea1ddab337a77f02d192e704f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4777a3ac3fc0e14bf667dd44bbf627e5040e8fd00d15be121726fb2def064ced"
    sha256 cellar: :any_skip_relocation, ventura:        "0a62fb5c4f7b7d57cba6985c24aa80ed30d3acec43100e7f23a65f349ae1410d"
    sha256 cellar: :any_skip_relocation, monterey:       "107ff93ffbd3c268e32968e874ca4ecb11c0461c5d272df9bab6144eba58b011"
    sha256 cellar: :any_skip_relocation, big_sur:        "e63ad10d509d4ae8ab24720fce6c1a047ae4e9c24e80cdfd284c019354fddaa3"
    sha256 cellar: :any_skip_relocation, catalina:       "52e0376f6e047b6cd0ef4a3fb82aa3c59c48060bd8a13841f1443f9dd8c18c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "553648100266b8cf18af31b37f805be91581efcd48b457ef339cf6dfd9babea3"
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
