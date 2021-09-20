class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.160.1.tar.gz"
  sha256 "5e687fd12d4aa0cc491a21d510f7756eb668750722707b42aab941aa259aade1"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be5166a2a7c745c165f77bda1bc9f5e854c9a8ad7938d6ce59f2fbd0d29601b2"
    sha256 cellar: :any_skip_relocation, big_sur:       "f6960260a2696ec26ed7b2877a8ce0d55350a25fd3d19423ee4b72fd44a1d6f0"
    sha256 cellar: :any_skip_relocation, catalina:      "051fe2611c27329b2fe070fa89e72b51e9948dfdb887ba82bb3764e188eddda5"
    sha256 cellar: :any_skip_relocation, mojave:        "0bd06d55375ef51041a520f1c4b89585141b811f8b2aac8c73da050f936e82da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2f4252a2bc4a65d4f159879314623abf4c87a9cc3c75b81f2979a3f2109a0b1"
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
