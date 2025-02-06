class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.17.2/dune-3.17.2.tbz"
  sha256 "9deafeed0ecfe9e65e642cd8e6197f0864f73fcd7b94b5b199ae4d2e07a2ea64"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4db825f04008349cb3bd864767a296829bcf61eb4547d22990860022477a258f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96d8b942c5a388dc28f85bd947afdbfa21253de635a43f413715842e9bebf891"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "852e18589c50188f0ddd0bec832c17c74b9400d3c94b6c3ecb10da9babe9d61c"
    sha256 cellar: :any_skip_relocation, sonoma:        "02068221cfe11994b6eb57844702958102400a2c8bcb2df2bef0f39c6c9b542c"
    sha256 cellar: :any_skip_relocation, ventura:       "f695643b50ac1d1695cc854cfe2f34ebef17ab04022dfec2a88f8b4ac34438c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad6260942a57fac0a9ed9a6517858de4e88e29e56b0ffc6ae21ca4f86d07e9cd"
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
