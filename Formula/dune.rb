class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.0.0/dune-2.0.0.tbz"
  sha256 "9f993b8263775a2236fd4308e2fe2413d3ee925a52858e4d9e18e7f170c4b3f6"
  head "https://github.com/ocaml/dune.git"

  depends_on "ocaml" => :build

  def install
    system "ocaml", "configure.ml"
    system "ocaml", "bootstrap.ml"
    system "./dune.exe", "build", "-p", "dune", "--profile", "dune-bootstrap"
    bin.install "_build/default/bin/dune.exe"
    mv bin/"dune.exe", bin/"dune"
  end

  test do
    system bin/"dune", "--version"
  end
end
