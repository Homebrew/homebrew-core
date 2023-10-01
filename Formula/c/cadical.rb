class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.7.4.tar.gz"
  sha256 "866c8a1332ff1ad5dc7ad403bdef3164420f3f947816b5c9509aad1d18ada7a1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5c644766ae64fb3e1e7dc4b4afa509b676ed6085125cfb95698e6e68f712a82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cebf996fcb5f645743700cd9a0b146425183a7d57f8f1d095bf8fc6f189c8584"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5e485cb7e2a53e0adc5302f70bcbe2429e8f568df8f2e9496ed657f290b6316"
    sha256 cellar: :any_skip_relocation, ventura:        "4211e48e6f78c57c2deed6606f92c47cd4b1fadc8d4ca5db71ab60ea5ae870b9"
    sha256 cellar: :any_skip_relocation, monterey:       "b2b7710d8ff936dbf1129f9f74358965ff2c5f0a48228d58bbba0d0b6745a2f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b805a2799550a219abe236bd5324943919d02598e9034ad01e4459c75a5fc27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22461e495d24f88c94834ae03d3db3a6ff5fcec94c8596b2bd3ba2ce547cf790"
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
