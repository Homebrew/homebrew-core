class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.162.0.tar.gz"
  sha256 "eb5ae96eeb4ca312127ab3867e6fe401474745bfc09259eedc3fedf3f700b3b8"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "75001d4a378d0db2c69b43b9b3f1a74eed60499f66144e601e960eb08f0b38bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "c316d64c534ab94c64087f0d37b6b9418108549b00a5e49d127e2964276400e4"
    sha256 cellar: :any_skip_relocation, catalina:      "c97d1cdfa7b417fa7803b816c86f8f169848ac340633b350d2f10ece1e742cdc"
    sha256 cellar: :any_skip_relocation, mojave:        "6c14ed9fc069390e99b67a2ad2b2e0d28d8f16c606a3d0beaee66cd7c9c4a397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d79f900c78bb566c5a980c17c57ecc887168bd2bcf1b2d89f2f6e8b26aa2806"
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
