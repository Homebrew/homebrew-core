class Makefile2graph < Formula
  desc "Create a graph of dependencies from GNU-Make"
  homepage "https://github.com/lindenb/makefile2graph"
  url "https://github.com/lindenb/makefile2graph/archive/v1.5.0.tar.gz"
  sha256 "9464c6c1291609c211284a9889faedbab22ef504ce967b903630d57a27643b40"
  head "https://github.com/lindenb/makefile2graph.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af7dba0cbb045f067076706310b30c52eddbd6732e60d16017ccbfadd4bc866d" => :catalina
    sha256 "5b5cb69a698628af41b3de70146580bbcb2e88a8b6d87d7fe9b4f58a2f2fdfb2" => :mojave
    sha256 "51231ed0ef44fd31a10f4ea0a7500570181332786ddd5a8a9a886958ad1b1408" => :high_sierra
    sha256 "274ee025c45df9757d608249d64105b9314c8e59fc52a81ad6906f807498b67c" => :sierra
    sha256 "ed1939b1b0fd106f3e328e310a887cf454b81481f78fdf57ce75c0480a922d7d" => :el_capitan
    sha256 "37aebae489e0f341f80417ec711e5c2817f5b8097c3493dcc11bc754bdd1b1cf" => :yosemite
    sha256 "0de3d4a2492797c3259798493e287ac2403f02254c6cfcf74948a16bcc4bcd0d" => :mavericks
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
