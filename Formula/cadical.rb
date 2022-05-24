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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56c14010ece80c5889af1c9f4f87b0e7890dad48a686c8f5c8430299812eaf48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2ede739d74122cd47e687aab34bcaae1ed69e0c7ff41e2b8390befd0c959d31"
    sha256 cellar: :any_skip_relocation, monterey:       "bec982b9cd3bd2ffe04b0226dd34cdde9278f1fe54184fde851d9648b0932cee"
    sha256 cellar: :any_skip_relocation, big_sur:        "abf51a356e0c2567a306981f4178a76279169e7040fdb0cbed914c5ef0f67c66"
    sha256 cellar: :any_skip_relocation, catalina:       "b31d7cb63660964c6382e78f49065b67a106ba19d7ba0b0e108e7438413bb058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a508084a9b72046fda4f6cf6543b4402626aa14705b12813f73bd343edaf57f"
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
