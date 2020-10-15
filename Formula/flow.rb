class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.136.0.tar.gz"
  sha256 "a2cfc049fb655dd78ef12dd6cbd35b5e36262e2febd4f3ff39e8963a3439c1fd"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "51b7334aace020e0b49e9a11c2ae35d7f108604223658dea5fb1c1a6398507d4" => :catalina
    sha256 "4b67def4dcdb2ccbdf88349710f7014d0be2b8341fad415e19f8f5e30aacd02b" => :mojave
    sha256 "97f793c564ee292876aac076eb447c2f26591aadb37f908e27ff2bfb831836b9" => :high_sierra
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
