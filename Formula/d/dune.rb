class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.24.2/dune-3.24.2.tbz"
  sha256 "472798691b0216daf538709f0f4703b3617ef24ad0866c9096068baaba4d762a"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12c3d86b9fec629cc684bf27fc7f582458aab195a96c7f587c3d9caee0069156"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b56014ff9caa801b199d477f623fcfeafc55ddb28ea388273c67201b602a169"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbaf5f880c670ccc6fc55582db2e9fb51ba4a8f831e3fdaa316f77c000396852"
    sha256 cellar: :any_skip_relocation, sonoma:        "939f77f1b7b6a4cc98f0822ab57f66d286704c63c9524f7404d902f4264a5c26"
    sha256 cellar: :any,                 arm64_linux:   "1bfc1c74b22b5bf74a0cfe4a6bb6fa93d5673b4d8cc56c38640ddc6c9bfe7b8b"
    sha256 cellar: :any,                 x86_64_linux:  "7e77141e7a101059d149997ef6c88b403c78094b30076f0000ec7ddb20266178"
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
