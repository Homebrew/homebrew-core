class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.109.0.tar.gz"
  sha256 "7622894367c6f994a1758a50a940a2f0bbb41885e333919f7ef230547e551c86"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce53b785b3432be57337c163e6c6f6439976651966ff8d4cce1d6076a570aac0" => :catalina
    sha256 "d4103d448de5478e0fd5ee2df5415f822c96dfc568daa959d2458e681980efe0" => :mojave
    sha256 "955d2147f5de267756130947811a1bf35e3ab4322f330d0f9fe16d5515831c7d" => :high_sierra
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
