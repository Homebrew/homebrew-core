class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.99.0.tar.gz"
  sha256 "e2cb9b3f23946e33a72e10aeae14bd4aa3f5d038d49dfd8aede4ab333600101d"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "42b6dfe024aac7f741c8e3c3ee958d64daadf0c819a4134238b8bbcd42e27044" => :mojave
    sha256 "95cdfe5c0a2234e3d6dc20af3b739c23e6a5615e6b6905d11c833ab7c6c29a18" => :high_sierra
    sha256 "0a1e83a35c704c3d57e968dd9c172431482b7165c3eb2e9c66ef57c530834107" => :sierra
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
