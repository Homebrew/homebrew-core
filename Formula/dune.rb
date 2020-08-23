class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.7.0/dune-2.7.0.tbz"
  sha256 "b417ca85bdce4171e71255be4a9c5a7572646cb1dcb221bba3757dc6ac8f1c15"
  license "MIT"
  head "https://github.com/ocaml/dune.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "637ff9902fcd06fc9f048c5bf1a9214d0bd8b3a8a883a8b312650f1972985dcf" => :catalina
    sha256 "b1825a28dd391ffa2b3d4eadcf5495523b37e0fa63dfd92eaa067e51fa7f6f27" => :mojave
    sha256 "4d70f58146199488cb87c607b691b962cdfd0ccbbf13852af2e835323ce554a7" => :high_sierra
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
