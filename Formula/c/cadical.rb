class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-3.0.1.tar.gz"
  sha256 "0a8ea563b5a25f5aa064634814edab45cc0e45111ea0f5d412a565f806fd7e11"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77962818debd60f5d12591b3dc589f5ceec70f7fc3fca65b69cc145ba06aa76e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecf44191d1ed10a61bb47ce009d91e520abc637fbcf3608004cc7cf463fe2271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5632faabd6d7090f603752a52eea7ace1cc7f101694eef8f7a4eb8de66803d35"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd05c41f479807a91b72b33fc3f120d40d25e416e8f5adbbd988ee462865a85e"
    sha256 cellar: :any,                 arm64_linux:   "d3c1c53581a8f3f802a062318f9a4b23e503fa0bf9846040d69dac729ca421c5"
    sha256 cellar: :any,                 x86_64_linux:  "cef0be1bad5d61be121bd000090bf1639d2ac89279892278312b647742c38625"
  end

  def install
    args = []
    args << "-fPIC" if OS.linux?

    # No options in `std_configure_args` are supported
    system "./configure", *args
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

    (testpath/"test.cpp").write <<~CPP
      #include <cadical.hpp>
      #include <cassert>
      int main() {
        CaDiCaL::Solver solver;
        int var = solver.declare_one_more_variable();
        solver.add(var);
        solver.add(0);
        int res = solver.solve();
        assert(res == 10);
        res = solver.val(var);
        assert(res > 0);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcadical", "-o", "test", "-std=c++11"
    system "./test"
  end
end
