class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.159.0.tar.gz"
  sha256 "0b82c6a406513e7b10409a1d25817f75519802d49e243e82447a82985fdf009f"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "98420411763f05f8ff3bb1464ec28221253611c29d2625175257e3631837f9f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "6004f6e8b3285cfbb918ef30f1bb7f1dc87eb0e3759ff481023c6338e146a3c3"
    sha256 cellar: :any_skip_relocation, catalina:      "5216caf6cd99cdeb17f0f9c3d12fd5f6163ab9249dbfaeb2015ce0128b8ffeab"
    sha256 cellar: :any_skip_relocation, mojave:        "ff5858480b8f1f168cea402077e4be3155081cac2388ec7e76e15f7179987be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebf31c450a677a090a5e343e271798ed01e9316f49b944e29f3f42dcc803f143"
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
