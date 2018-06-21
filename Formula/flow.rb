class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.75.0.tar.gz"
  sha256 "cf4374db08603841d8e98b18ebeb29dc3024073af5e9f3d0726b961dab098d08"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f27f9cbd271aa99fe5f8301d92d44fce65cd0e60a22771297fec75da9e4b822" => :high_sierra
    sha256 "9eb950612449ba34de07e755047b45f3689e65448aed82b7913ffbc18eb94c99" => :sierra
    sha256 "8d8071d6ae2a4f982eae548bc5e0816d03187635ad112147092e61faca07a5ae" => :el_capitan
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
