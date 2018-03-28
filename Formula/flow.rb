class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.69.0.tar.gz"
  sha256 "a3626deeb1e2d4e6a4c15e2f43bcc168aa449803c919b8c7d62697bdfea20516"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "53e4e9ffea13d08cc1e5d027e4d6d091188c7778aec528fb6aee215bf786656a" => :high_sierra
    sha256 "70d963d21a0732d57637c560fd18de300a9effc4b47614cac2d80fd14ba68d05" => :sierra
    sha256 "2a7f240ed3d2bc04344461ba29c3e887021b00755d638737b18ca21c2f7127ec" => :el_capitan
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
