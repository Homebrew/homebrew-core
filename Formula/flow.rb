class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.116.0.tar.gz"
  sha256 "155c0702a81a239a5043d37387720a3e2fe1f9f68798cfa5009d7d52efe72b8b"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "539332af010750dd0abc3248baf72db4e27f8892987184344a64064f931cbc34" => :catalina
    sha256 "1b1a2f8861f1febcf4ca0cd58bb98c3163fe4ffea166c44123e2ee59051902d3" => :mojave
    sha256 "1237250a9a0b30d07e93f70162e5a1402f9c3b97c3df7544bd7c1ca3538f8bf2" => :high_sierra
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
