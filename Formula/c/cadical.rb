class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.9.5.tar.gz"
  sha256 "fb1850e08c578229c8a3a020673fd65ae271c54f0ce660386a0de952bfd7b2b0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9f3671043f8bfa9b9e0f3c5abf4dfcd22d5196fc98f443fe18da64a31b52c46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85a248555403faaecc91e3a4e6b23df264a8f19b12c9ceb18b97c14f6bdee638"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9256af14f70ddd1a2aa0f82360ecd6588f64062db8b7612c44c946648dbe004"
    sha256 cellar: :any_skip_relocation, sonoma:         "120c3268b72aa7e247f48a2d88ca6391cd1ddc9e8ba4e2fe325cea304927e651"
    sha256 cellar: :any_skip_relocation, ventura:        "8a3c7f6bd26182a091090e0545e1eda666d9a832b27c5e9d5bf21e8eda61457f"
    sha256 cellar: :any_skip_relocation, monterey:       "9547d6f7ff7949816dc6ad460133291666273edfaf9d50ff85ef52c21c6beaaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98f89aa84b85ececcc7ec73e656bdcf06908c1e4e30ee8d3df76c27f7ba1c50"
  end

  def install
    ENV.append_to_cflags "-fPIC" if OS.linux?

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
