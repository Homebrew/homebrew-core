class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.97.0.tar.gz"
  sha256 "a3038c1d678a42ae3867b94c78a7b20a7f01649a8759bc97646ff9a9e70b147d"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3424bf8caf6b150a8024553450989f911f3982af8e4c3969d8119ee6c04c0f31" => :mojave
    sha256 "14932e2ddf5cceb18ce42053510d31c61c05dfd12007ffe3ff5a25b4b30e869b" => :high_sierra
    sha256 "37735446db6bab5e742807c00b9810bdc042edd389dbe221e1db12cf74fbb488" => :sierra
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
