class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.183.1.tar.gz"
  sha256 "b8c94509877138610eca7d52a4f545fd0457cd7c1541b147e8df2d33f8987110"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e4b988257ac3a2e60f3bd8d1306d794095f50806c5dcfb830fbedb62040c417"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1442579416ea2c44cd847d1f7232bcbbf163285e17c32192a508bed81bc137f9"
    sha256 cellar: :any_skip_relocation, monterey:       "e3ec45c0b8c5de3ad872a0614d361ccb4b4bcbf00af2b184d84f8e6b279ccd22"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ab3d982dab6ac3562198c9b2a0aca5cc12c2467d4aabcacd53a2fde972f2159"
    sha256 cellar: :any_skip_relocation, catalina:       "a38c3e2ad2b794cb978a6314163ec6795517a5513842d3489ba7d0e6ab22f558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58d80faac236473606afcb8b67082b8067c510962359d86d8e320a66148855a2"
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
