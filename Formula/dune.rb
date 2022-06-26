class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.3.1/dune-3.3.1.tbz"
  sha256 "840c80491bfe12bab5f2b99d49e163f3e4c4d2fc4b4a3e6fb16c24dccd5502e1"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3146026708210229297a97c38a67cebbe44507bc8a35ca6f4d77c1b80d162618"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "720ad5635e8291f3b549544985de3e9387e8169f69aa1200f0f5be8bfc443560"
    sha256 cellar: :any_skip_relocation, monterey:       "27da632b313bfe7b66fd804a9a712cd959247b8bbe560e4f34d2eeeca2c78929"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1ed63f8c5e51cca3ad344b254ae7629973f58cb584dfffb636b7e546b9aeed9"
    sha256 cellar: :any_skip_relocation, catalina:       "29a84bd4fb94f7fe8cdb49f9bb3388a27190594a597beaa9511d5c5386c99a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59e74e6f97c9f86b24b2d5ad20e6ba13e2ddb7517f8d06b9fdc66d66b3064924"
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
