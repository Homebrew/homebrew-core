class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.150.0.tar.gz"
  sha256 "799e23c1885adeebb2f1fa8595db3a78f0d074fe38314394db960d2de7c53e99"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "1838b3fa0b7a252776cf38c946a82b06bdb79d39720436b1bd42fdfee29491e5"
    sha256 cellar: :any_skip_relocation, catalina: "ec70620cbbb6084fd71b4590c6e833d29d4bbf5af9577cec849ae7b31b40f15b"
    sha256 cellar: :any_skip_relocation, mojave:   "3f6a8bf1e0ec27445aff3d269ebba7113a93b6e70b296ec2fd19b5874bbfe5a9"
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
