class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.95.1.tar.gz"
  sha256 "23d90d758fac905ee018926448c6b1aed5a2ec9832e829307840ee409b5161f6"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "da634c9ab0e0b3505793e7be06a098dc2fabb1a6abb8ee984a3ea8085d1149ab" => :mojave
    sha256 "1d0b0fc9f7f0997de5404e151bd3b18ba51fffa4cb11bb65beb4a20bfe3eaa7c" => :high_sierra
    sha256 "5221b2de9a9ecadcb98af710c4c591baaeb4f1508eda43a60d4eb330fcc5a1b5" => :sierra
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
