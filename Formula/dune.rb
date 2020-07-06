class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.6.1/dune-2.6.1.tbz"
  sha256 "5ef959f286448ee172f1cffc86c439a6f7b662676e6015b282db071bb88899a0"
  license "MIT"
  head "https://github.com/ocaml/dune.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20b66d941c17e2490aa2aff29db3aea6b5f857bc622affdae9621bd8f85ef175" => :catalina
    sha256 "359eb57c1c81d632082e05dfd43299cd972271beff51817d9f8463369b096f0b" => :mojave
    sha256 "2806c727b972d5e3b8d1050155c3cc7380e1ce5d5dd2939d8839df9958be8d3d" => :high_sierra
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
