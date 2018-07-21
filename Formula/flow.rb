class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.77.0.tar.gz"
  sha256 "30d176bc9a88687b9ea605f3bc8aa3e97100984a71f883173e033634d9aa3e6e"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d293ad8769ee6a45976622446e11591d902db98396ec34cbe98f432e477fe78c" => :high_sierra
    sha256 "1df829fee4458b71545c2fe39dfb269ab9e03eecd47b7429d573d84efdf079fd" => :sierra
    sha256 "5191308c902514f8941ca7b3c2f114e9d190ebd7f44d4343436f9241729c23f1" => :el_capitan
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
