class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.49.0.tar.gz"
  sha256 "f682e87c95baba37f8303534a91b7518b9281299bc78fd4c568f893e4b7bd3c5"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d05f27bdcc36e5f142bda40560a98c3f7f5acaa10fe301904b632651d962e453" => :sierra
    sha256 "e71d050e7205ac330bb4d09e13e5bbf3e53127d83bedbacbfde5424fe5da31bf" => :el_capitan
    sha256 "6655d84fc3987f59b2827c9ff43383a6153b485c286e76db14c17ce50eaa5dad" => :yosemite
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
    (testpath/"test.js").write <<-EOS.undent
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
