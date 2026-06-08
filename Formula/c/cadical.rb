class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-3.0.0.tar.gz"
  sha256 "282b1c9422fde8631cb721b86450ae94df4e8de0545c17a69a301aaa4bf92fcf"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2967cc0540cdaf175371d3a4f566ada6998c14f565af4f3a0e844c38655e25d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34eb631b3ca9f327844f593b90c8caf146e677c34221dece4e06d6e70309bf14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "117549d37410d5cb9466328e14940c6d97aa1e7349536f146abac6df7e8dfb64"
    sha256 cellar: :any_skip_relocation, sonoma:        "c79fc253f0b70e9271afec97af7ccfa616c27399ae98469493bf269cd0329e27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b1269bb97bdc24a8a221815916362376d69f3a9f200adf44eb7052a6cb37161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d52a60004435c341e172b804ab0aa96e12170ab4b94e6f2919707a61f59b9e6"
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
