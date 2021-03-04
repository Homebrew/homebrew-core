class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.146.0.tar.gz"
  sha256 "7221c17e56511ed7ed3770c04f8aa193d841c19dbba70737b4c89f45d094179d"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "60e370175816a336c126477a016bd93e9e60e25d5609ad22cae873ab82dc347d"
    sha256 cellar: :any_skip_relocation, catalina: "f6f8094396dff60a63e69fbe033e645956f5a717684e44076c03ae641a85c273"
    sha256 cellar: :any_skip_relocation, mojave:   "9423f65bd794d27704cfadc93ee81d6b9a0bb4a9c993645fb9c6bd229d0395cf"
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
