class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.108.0.tar.gz"
  sha256 "2f8ca38795771ef9962fc993bcd396426649ebc9ee9c7ee0e1b14cac638b42ef"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbd37249bb844153f18d5a67e07bd7a95c0d1df00366a7b48a123e691289de13" => :mojave
    sha256 "2437460a3ab694e1d7adf6b9b1401ef23a4edc74b642b0e7497ef9779e11e540" => :high_sierra
    sha256 "431578b7bf9675c36bd64e7f5441c4d79895eb5f6563e5aaf0b08ee6fc69e83a" => :sierra
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
