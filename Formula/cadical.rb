class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "http://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.4.1.tar.gz"
  sha256 "e20e16dc198f436480317d98c9a2049d145d8476092b181560d86034360f725c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c19d4807b7bc2ea2eff3a15fbf25c6ebe4a660bcd84088d0a17ed8de401e715c"
    sha256 cellar: :any_skip_relocation, big_sur:       "780dede4d1880b19f2b5675c2de1dcf92aeff4b03cea584181c9dd52acd4ad62"
    sha256 cellar: :any_skip_relocation, catalina:      "df66f1da5a5d384cf9b90c6c9c93f1546f057d4b21479973115be0a27fc3534e"
    sha256 cellar: :any_skip_relocation, mojave:        "928b030fa849f45665d3b0cd0b9afb1de01130caab147d51d7b0e8e2416224cf"
  end

  def install
    system "./configure"
    chdir "build" do
      system "make"
      bin.install "cadical"
      lib.install "libcadical.a"
      include.install "../src/cadical.hpp"
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
