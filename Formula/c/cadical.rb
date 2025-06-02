class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-2.1.3.tar.gz"
  sha256 "abfe890aa4ccda7b8449c7ad41acb113cfb8e7e8fbf5e49369075f9b00d70465"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13599f5a5a95eca75c9cdac49ff39ed271834ec54068742d456b5a16db68d04e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e48caf86797f6b6d72afecdd0271e0d5665af282801e2fa556d3f86066a7fa76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ad047a3437ab8c0c944c44c7cfa977704781bf69b176658a21324d4abf0a19e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7d6caa39c55c9c21a1e4224d2bb754bbc31a617ae795f63a68986db92f83d2b"
    sha256 cellar: :any_skip_relocation, ventura:       "f8b6bc085363d6e92db05d37cd4794a646ab858e8feb8f53d52845a3c1cee21c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bd60910c6fe37fbbfe153494ef5d20d139c4afdcd242f356d7999243434c328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ccda8639207be39bbcf10f84c36c520c433379be429100d86e6dca26a21ac09"
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

    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcadical", "-o", "test", "-std=c++11"
    system "./test"
  end
end
