class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.8.1/dune-2.8.1.tbz"
  sha256 "e7b405c75af321ce6518aa8e70ebdd403dbcc2ede931713e69c2b5addda4bd44"
  license "MIT"
  head "https://github.com/ocaml/dune.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "acbc6455bab7782a25ee9d11cbffafc56e3767fc78b203a2bdf23c05c53757cb" => :big_sur
    sha256 "6ae3ed69dbbd8e769a6c9a228f71cc31f825a96aa21ee4f317a7d70608dfb55d" => :catalina
    sha256 "f4e2865ca92172a51eef022f4a353d54377ce0f95920e978d55ab5ea8da6e762" => :mojave
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
