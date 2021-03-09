class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.8.4/dune-2.8.4.tbz"
  sha256 "4e6420177584aabdc3b7b37aee3026b094b82bf5d7ed175344a68e321f72e8ac"
  license "MIT"
  head "https://github.com/ocaml/dune.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8e8850532c2b926e92f651d89f696176e8313add0b71dc08d2d38a99ce4aa0e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "03ce60177bd68e88e95cedfeed16d0607cd7d2918448105499100fc04a15880f"
    sha256 cellar: :any_skip_relocation, catalina:      "16b4cfd6d9ac43fb4505baa012c27202cc219b20d3986e2f03dc9f83b82838eb"
    sha256 cellar: :any_skip_relocation, mojave:        "a65132d4b1b5928b8cfc2a2c3cfbb55185ae67ca30705ed80bb29a6bd09872a0"
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "make", "release"
    system "make", "PREFIX=#{prefix}", "install"
    share.install prefix/"man"
    elisp.install Dir[share/"emacs/site-lisp/*"]
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
