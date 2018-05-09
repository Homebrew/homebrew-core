class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.72.0.tar.gz"
  sha256 "82468fe78308785b958f85f931899e0a703df65b8cc4ce1184c301f274f7fc84"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "94ececc6fb702b46aaceb565cb41f5943bedc03eea3a7d6050d515b93db0a659" => :high_sierra
    sha256 "93b426023afeff6386b872acfd285073aee21ff4208e50754f395e279acc8ba8" => :sierra
    sha256 "3163b67e0fd8a236f8e16331f299c3ef0ea0718693b009a684889731eb007c89" => :el_capitan
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
