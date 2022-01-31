class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.9.3/dune-site-2.9.3.tbz"
  sha256 "3e65ec73ab2c80d50d4ffd6c46cbfb22eacd0e5587a4be8af8ae69547d5f88d6"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dff83bb542bcd1beb4fddf7965bc4e51d5c3575da59c0719647534df50eb37bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae69be7082e78cad895c5377c158881c7063b6f43d8bb4211a735aa424ff0c24"
    sha256 cellar: :any_skip_relocation, monterey:       "2e55f5af9300013485a4ce7b31294ec1f6e2220e73d641a3c329d315dfb1b2da"
    sha256 cellar: :any_skip_relocation, big_sur:        "70559f83f94845a6a5f055fa7ccb53d849a7fe8df969aa58e70d9e6eeaeb9dfc"
    sha256 cellar: :any_skip_relocation, catalina:       "9364090d1fe8cac052e73af4791d7f709156e8be547d9e58a52ae97eec8fe5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75b4c5a1271aae59f6fae9269f76f0320b9976a5b14be57193d380596a2363b8"
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
