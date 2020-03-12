class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.4.0/dune-2.4.0.tbz"
  sha256 "28f1484a798103021833d544f1a79b0234cca77add49bba073013eae94b9dc24"
  head "https://github.com/ocaml/dune.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6012a81b994b9e93f7bb628a3f719941f9b86b3459b9faa75ceaeed28f36c37" => :catalina
    sha256 "32b7ff21d8be5722348978803086f725019c19ad41867324156455ea2096a4c3" => :mojave
    sha256 "c9aaa7e7182f2900a8f8ccf3e6139232115190e235bf5108ac9ef709a8eb6779" => :high_sierra
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
