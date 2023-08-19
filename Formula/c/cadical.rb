class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.7.0.tar.gz"
  sha256 "9486f06c885e1ae1db0401a64edfb5230c912b024a04ede487528f859f22ed35"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c962bc299a955455f74ebf1ad88331187a674687a4aa91a9a078a9ec97441930"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "185ec493d1310014afd295d108de383bc131dceb0c04dd26aab2b690ce6e064c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d3c39e9c6d908a91b991cd3d7afbe4abdd4d7f1cc53c81f1d5033d30007af87"
    sha256 cellar: :any_skip_relocation, ventura:        "329217d2041449b4631e7527b85664bc45056933b93b69ca4b35b26e848e0df3"
    sha256 cellar: :any_skip_relocation, monterey:       "75a5e23c066dad13727407357499e22f7a6dd148d1ec86968df88de5d6f961ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "95831d09ef8d5d8c7d2180837ab2302dfe176ff02e08666c990eafad3fc6fe04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7899b7078ac4e9d1291f704f517e1afb7eeb1738c1e19fa5d181c78edcabb241"
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
