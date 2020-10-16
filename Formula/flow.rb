class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.136.0.tar.gz"
  sha256 "a2cfc049fb655dd78ef12dd6cbd35b5e36262e2febd4f3ff39e8963a3439c1fd"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "810a304b9686056dec219487c02d378a2c385ac294ae29c074713aed21118a61" => :catalina
    sha256 "d59f2bf655607f351860c4b6cbfd480235ffc653e7cb946d5aab61dc2e3c7328" => :mojave
    sha256 "9f858cf1f8e2076eac7f2ddac1697cffa114ba5b2049b72624d712fd20fad90d" => :high_sierra
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
