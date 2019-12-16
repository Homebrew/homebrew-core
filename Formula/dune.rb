class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.0.0/dune-2.0.0.tbz"
  sha256 "9f993b8263775a2236fd4308e2fe2413d3ee925a52858e4d9e18e7f170c4b3f6"
  head "https://github.com/ocaml/dune.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d04ec439b7840934c4012fb2b6b77a314aa351ea6c01aab3b82a9cc64923c4e4" => :catalina
    sha256 "fd485e948769c2e6359765a41c603d9c2e154f3fc1e2ca6f01c65969a35d6a60" => :mojave
    sha256 "2ca309ec2e3a608f1c901a82274017fe96827b119fa97c5976e9ffde75f01017" => :high_sierra
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
