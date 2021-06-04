class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.152.0.tar.gz"
  sha256 "1d05c8c97e947c6e171411af2dfe44ef18d756bf150792b86ff96a8249e0ca53"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "eb3cb4cdc051af2ab0c74d23d3a8d81464b7128b52ee4af6d2ab695c2e4bf249"
    sha256 cellar: :any_skip_relocation, catalina: "442b1271eec6da2a0e0a5738108653c7d469f8de5c07982117c727aa0d9fb2f0"
    sha256 cellar: :any_skip_relocation, mojave:   "0f285904d24a94b0f15da4096f586a944e0bd135eaa88b9c5a9cc7a89c6edd2f"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

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
