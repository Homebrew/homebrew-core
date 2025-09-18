class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.20.2/dune-3.20.2.tbz"
  sha256 "b1a86b2d60bdb4a8b9bb6861bdf2f9f28a6e7cb5d833ce81afecceb9ef9ca549"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d93a6f02c5716b96f58987cf3ace9b3ef8be6720a27c4f2aae1123052717bdce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "533d58afd2a4feafc0fb38140f6a8f51868483987e7ba3a892b85cfc804950ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc6a9aa1bb3058d438616dc8ab30c48e927254bb49b84cb6d18bae2dac0299f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "097aac472568b94c4bfe357b32c239554fd66f0c813bdeadcdc37012542894c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "abd95c80b48c98bb48163e8bb673e451fdd06e5b8c582934e09ab2e18a212b53"
    sha256 cellar: :any_skip_relocation, ventura:       "131149817be6d7bb09fc34c0482743636e25468e4f6b69dca1de224b7a13fb88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "402a4bfbb4af0f475fd209f8b214fb4883a982f8fd0f8cb4f5f818dff675842e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e91d5e72f427d773cb585694784269c6bd4354dd973b874f2dc57d058e16715"
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
