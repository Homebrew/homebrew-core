class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.79.0.tar.gz"
  sha256 "79f53225540d0f6cd5a908e772127426bb857001907bc1ff8a1e0ac12a310257"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8d35e3a50022de2a83945bf6f2c40f27467070cc089180c4045d2e32d7e1ffb" => :high_sierra
    sha256 "fb8559cec27450f6a775f71f2a8019a0100ebca1cee8c99a9745fc606b5e8c75" => :sierra
    sha256 "ce2db31a868a7d229a3188e0a2206c7a840b32e641fd97073d01e889ebd493b4" => :el_capitan
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
