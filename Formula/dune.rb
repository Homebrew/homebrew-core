class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.5.1/dune-2.5.1.tbz"
  sha256 "8f77d3a87f208e0d7cccaa1c48c4bb1bb87d62d07c3f25e9b8ba298e028ce52b"
  head "https://github.com/ocaml/dune.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9e20a762026b9f3144aaa3c142e34717ba4bd965fdc15396d871c1281a7b787" => :catalina
    sha256 "be4d441437c8e0a586fbe2085d84de2e74bad886ef35a4fa60f5f1edda22b875" => :mojave
    sha256 "c366a17ed9c20893b079ba368029a2a42ce62034c5ecfe3ee26540c6b3172553" => :high_sierra
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
