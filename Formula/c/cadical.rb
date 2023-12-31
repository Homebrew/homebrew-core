class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.9.3.tar.gz"
  sha256 "4ae1ecdf067e7fd853f69105f4324de65f52552ce2efb6decb170c8924c4e070"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13b837a9034ff0a1ad7a0af153fab6c4a7106fc5318f2c7af6389ce8fe8c1d46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f271b809b40e12060400e268c0f9428df90d8295305b0439e75d574d6c0f33d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b22034b8fdedef13debfcc725cbfd7bf1558ce74533466e1014e674a985726b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b96e0d337aa447c7e38fc365875810ffc62f814936dc3d64c98d547f5aca65bb"
    sha256 cellar: :any_skip_relocation, ventura:        "00871826a5f2600d9e3b48106e9126f4a8d30fabce0bcc4cd7f8d8f85672d306"
    sha256 cellar: :any_skip_relocation, monterey:       "192920c2618906fbe106392fc23cc66372176a60c38e15f9a681c2639a26dc96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bf4ff7f9cc4b6b526a0b943af72b9a21c98a11ad044bb08ee6eb473ceb30cd8"
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
