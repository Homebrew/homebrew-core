class Makefile2graph < Formula
  desc "Create a graph of dependencies from GNU-Make"
  homepage "https://github.com/lindenb/makefile2graph"
  url "https://github.com/lindenb/makefile2graph/archive/v1.5.0.tar.gz"
  sha256 "9464c6c1291609c211284a9889faedbab22ef504ce967b903630d57a27643b40"
  license "MIT"
  head "https://github.com/lindenb/makefile2graph.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fbd6818dca98ad31cba381f503da9757dc4aebc6f450e8eb22b24d5bc2c04841"
    sha256 cellar: :any_skip_relocation, big_sur:       "c8278a8691b682c5499295a79b73e18e18e87c879384b7d44dbcc0f70178ee58"
    sha256 cellar: :any_skip_relocation, catalina:      "af7dba0cbb045f067076706310b30c52eddbd6732e60d16017ccbfadd4bc866d"
    sha256 cellar: :any_skip_relocation, mojave:        "5b5cb69a698628af41b3de70146580bbcb2e88a8b6d87d7fe9b4f58a2f2fdfb2"
    sha256 cellar: :any_skip_relocation, high_sierra:   "51231ed0ef44fd31a10f4ea0a7500570181332786ddd5a8a9a886958ad1b1408"
    sha256 cellar: :any_skip_relocation, sierra:        "274ee025c45df9757d608249d64105b9314c8e59fc52a81ad6906f807498b67c"
    sha256 cellar: :any_skip_relocation, el_capitan:    "ed1939b1b0fd106f3e328e310a887cf454b81481f78fdf57ce75c0480a922d7d"
    sha256 cellar: :any_skip_relocation, yosemite:      "37aebae489e0f341f80417ec711e5c2817f5b8097c3493dcc11bc754bdd1b1cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a5630eecb3e491ce11e781d86526ef8e81dbdcde1a951d4860be458cdc9399f"
  end

  depends_on "graphviz"

  def install
    system "make"
    system "make", "test"
    bin.install "make2graph", "makefile2graph"
    man1.install "make2graph.1", "makefile2graph.1"
    doc.install "LICENSE", "README.md", "screenshot.png"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: foo
      all: bar
      foo: ook
      bar: ook
      ook:
    EOS
    system "make -Bnd >make-Bnd"
    system "#{bin}/make2graph <make-Bnd"
    system "#{bin}/make2graph --root <make-Bnd"
    system "#{bin}/makefile2graph"
  end
end
