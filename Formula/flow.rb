class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.49.1.tar.gz"
  sha256 "d72a3470e7e0879d37f242aa0ec561ed0e60ff9fba676156392e46fd5e27a180"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2fcf505553faa13c53c29e90ca014f8c469726509ae2db4a78cd8dbfe42aee7" => :sierra
    sha256 "dd13ddca743ff23bb4461034384d8d7f5d5387f6d3f7f23b5891f9813af1aadc" => :el_capitan
    sha256 "722a6f3d185325f3b6a9884e10628a11870a07e6902d575a5fb7aaedb60e1fed" => :yosemite
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
    (testpath/"test.js").write <<-EOS.undent
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
