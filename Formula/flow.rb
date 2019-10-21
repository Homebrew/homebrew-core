class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.110.0.tar.gz"
  sha256 "51eb95542d9b11cdeab6e9da58124cca1644dc79d1af9aeb23ec9a348603ab70"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2607a83dfc0f723bface3dd15d486d455071df243f50d8a7ee2b3aa95c4227b" => :catalina
    sha256 "c176fa9b41a22a2098a07354d33d904967e877267960462db53835100a739a5f" => :mojave
    sha256 "b143e8ed1fe35ba81314c25dff885f92efe2b9fb6588df9be7fb240da9c3a7d9" => :high_sierra
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
