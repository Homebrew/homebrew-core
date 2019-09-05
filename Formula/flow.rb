class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.107.0.tar.gz"
  sha256 "170b7c0b724361129fe642dc57d5e4ada7a9e37290ebb52e55b96407a2227334"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e6bb0b2270bfc8d0db62596e1b58786659af8fbf839d5e5639363cca3ae3919" => :mojave
    sha256 "b66b3183952576aa549bdea7aa154e9be0d3309b4fa493d3a3c1e626fb775068" => :high_sierra
    sha256 "a817a020377bc5d7159e090259bb56b250890dcc8c6e56f1feb329b3f2674974" => :sierra
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
