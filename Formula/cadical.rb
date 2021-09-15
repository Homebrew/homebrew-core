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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ec7b790e83fbf0a79bdb56d42bd60b1bd84a0956628d6c6de9c41f692f99e5ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "fc095f38bfc3402adecdb2e33f76353ef95248f8bf25cd1731fc89c93070f7f1"
    sha256 cellar: :any_skip_relocation, catalina:      "1a5c3d28eeaf54b30f08b4ab5f27bf9c0ac366d4cb4f5003fe04d71ef11a26e2"
    sha256 cellar: :any_skip_relocation, mojave:        "c88a8df9110d4996b3f5bd00f3227e6031aeaf89c8ad652d5b8412f7ef441dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a316fb060adcad424dfa1f09b5c7d4ca40b5ead8aec27422478e9a26b6216069"
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
