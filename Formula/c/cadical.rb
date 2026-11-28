class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-3.1.0.tar.gz"
  sha256 "187fb83106e8d7964f1d409ebf056f3853105c2a8ec32427472eff734c9ccb01"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "057c5130393d21fe87b33ce42a279eaa5789f92498efeb76821f6cbb606aaadb"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "11ab537c42b14f88b9a35d21d4f95c2bdc43e7187c5c2f9ec73bc6d1137853ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83ff0c0e8421b9c8b1027db74d6fd4ee335b0104dd56682a70a9d9ae8b5b5f7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "822156060651b5974bb7d833b07b2ca32a4c875d2a5dfb7a9452f072747aa6ca"
    sha256 cellar: :any,                 arm64_linux:       "ba938baf40cad18e0a3806fcf9a36f34331767422916939de56806d47dc36da6"
    sha256 cellar: :any,                 x86_64_linux:      "84bf1ab4364a96ab913aa54b85443f82481b8ba949adaac51725ab798d70fcf4"
  end

  deny_network_access!

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
