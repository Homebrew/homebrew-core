class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.3.1/dune-2.3.1.tbz"
  sha256 "b2b3dd9cdfd34ef8c4583ea8c52c3503c2395bf94c264af19d6450547e12f5cb"
  head "https://github.com/ocaml/dune.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "85c393b5d58d4532b629f6df77cb4af2e364056d0b6bea15a525c20d73c4fb74" => :catalina
    sha256 "a944e88c670c15889938f9a4ebc98610df836cf908049240a21767699607cdfb" => :mojave
    sha256 "b9b25acbd30f617483ca96abe1492b030e2255056d9ab556ef5920230908582a" => :high_sierra
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "ocaml", "configure.ml"
    system "ocaml", "bootstrap.ml"
    system "./dune.exe", "build", "-p", "dune", "--profile", "dune-bootstrap"
    bin.install "_build/default/bin/dune.exe"
    mv bin/"dune.exe", bin/"dune"
  end

  test do
    contents = "bar"
    target_fname = "foo.txt"
    (testpath/"dune").write("(rule (with-stdout-to #{target_fname} (echo #{contents})))")
    system bin/"dune", "build", "foo.txt", "--root", "."
    output = File.read(testpath/"_build/default/#{target_fname}")
    assert_match contents, output
  end
end
