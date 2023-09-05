class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.7.1.tar.gz"
  sha256 "3bf00e2427e00d644c9e728a6e27a05dcb137c4c839196c1c4d3db007a6eb917"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0219a83241e893df64412f14a616d24cd3356f59326d609c3c851b5fd7a91e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9ba7d5c63346b22e2c0e1d36db30d3b6b0abc1dce6d328af205a04126019d06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9210c7fdfe688bd3e3f2629560b5118832c001b70ef44ff8a1e2bcabf7a9ef7c"
    sha256 cellar: :any_skip_relocation, ventura:        "2fcd576a9aac18bf0186f07ded1ca2c1408c16f5d2ff8a564443a5e945483d58"
    sha256 cellar: :any_skip_relocation, monterey:       "2cde1c48c105607f9153dc797f6cb7f8b9c31ee34b7bf1f4e74a6f42108356ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "c814314f6d32a986b7b7f41422fcb10e053da99c86db78aa819ffec1b92364e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36dc37e738eb8be5ab7a3d071d58a88ffbe3c012969cbdc4b9d3844137deb72b"
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
