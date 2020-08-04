class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.6.2/dune-2.6.2.tbz"
  sha256 "4f6ec1f3f27ac48753d03b4a172127e4a56ae724201a3a18dc827c94425788e9"
  license "MIT"
  head "https://github.com/ocaml/dune.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a6b7c488a6bcfe1b483d076f8e4ef4d774467620e45541bcd7ce34ebb829596" => :catalina
    sha256 "3ba9524cc8af5cc2f458216241e6a7f2b9c06908b0a695493974ce5b6ca6b1ba" => :mojave
    sha256 "f2aed7376f75f27b13a970b52134c266a97a514ae34e9ed468b611ed372cd321" => :high_sierra
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
