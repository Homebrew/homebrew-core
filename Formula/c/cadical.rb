class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-2.1.2.tar.gz"
  sha256 "292c2bb8d712d6d05fce3d3df63b922b8fa45e03974a79f7bae5bf68c284f131"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f75a21e1ffaa7f69973d7e872aecd66b0b4d163f7db768ed22bc1430d137d84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e2b2c9b7820a481982a846094f17945b3f928ff2dce150f23e63e12e33b5fae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f9538d411662d3bde8fc1f97f2a1764f435e62139933b296e481d1c0e197700"
    sha256 cellar: :any_skip_relocation, sonoma:        "223d1cba8975a91d4ab290906bc3d0abd67af495abeae867509d164baf68dd23"
    sha256 cellar: :any_skip_relocation, ventura:       "ffce6220b76e5d5949d12329a91c0225b2efa7b289ed12b6fb79937f631e6a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c879179500dbb11f645039212168444e0344553db8003c08d20c26be0aa552a"
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
