class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.97.0.tar.gz"
  sha256 "a3038c1d678a42ae3867b94c78a7b20a7f01649a8759bc97646ff9a9e70b147d"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2947cc4f6684265b6342e77de834953d3970408fdb809abdc59ae8a488ab88ba" => :mojave
    sha256 "353a8b769db94891be193a5c944679ce4ab61538006d099dc7c149e25330c97d" => :high_sierra
    sha256 "91533ed63fa86bb620f5bf8e7f90af01a939c4e53834370279cacda38e464b82" => :sierra
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
