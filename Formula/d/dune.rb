class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.18.2/dune-3.18.2.tbz"
  sha256 "56be509ffc3c5ba652113d9e6b43edb04a691f1e1f6cbba17b9d243b1239a7af"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "446457a03711a40ae442fd4ff1488a3956f305b96e2f39e95394e0e505711de7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcd7f0c2b09631ab856dc0ea3299c2837cae1d2954942fcc49da32f575c8f262"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "226692748d8a71a4196d3165902befa36fd9853b9bd5702dab0b20f3d43bbd84"
    sha256 cellar: :any_skip_relocation, sonoma:        "995f1913eaa6d741d777fa50ddb825a2c8ffe34b9e279a2a017c0617d7184ba2"
    sha256 cellar: :any_skip_relocation, ventura:       "d5805012973f8ba213113b1c2075b3928810ac6c1ff40c1b7b43eaf83b9c8fa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74a1443ac2017d098c67e5af9c32a0427c2003940ef7f90706d5facb29bbc07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "960c495a19d18be30ca5c8c5b37b459cd655159f471b9b05f28714b3f4cda9bd"
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
