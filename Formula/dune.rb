class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.8.0/dune-2.8.0.tbz"
  sha256 "07104d9a51c85f7100cc95e633e1f07e6436b0f0e68ab38e87328e74a9f0d48b"
  license "MIT"
  head "https://github.com/ocaml/dune.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f5a035846320482950c3f5763a0eca689de8c9b22c1c3a09583baf7cc6f8cf9" => :big_sur
    sha256 "a915f93d1b30931e577598deb935ca2326c523836b6fa0795db01bfd391911fe" => :catalina
    sha256 "4c35344cfb436b2238bf46846b382a4777a424da0b9ff1b769ed37c0f3f77520" => :mojave
    sha256 "b93f2bfaf0038552e9b7fba63aaf7ddb0cc53d464411f83d019b7044d83c49b0" => :high_sierra
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "ocaml", "bootstrap.ml"
    system "./dune.exe", "build", "-p", "dune", "--profile", "dune-bootstrap"
    bin.install "_build/default/bin/dune.exe" => "dune"
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
