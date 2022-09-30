class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.188.1.tar.gz"
  sha256 "e569e5d2f0c818738166546494ff68ab3c0cabbd638eead1a70221cdc0d067e3"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4488f143aefc4edd90be7d1cba6f7cde7cff25c3c90dd1c2367b1688432209f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d07492e21f5e363b929f0f6e0dbe4144acb1d4911a603f321a1a785b848e61b3"
    sha256 cellar: :any_skip_relocation, monterey:       "e2f6fc0caa750391d478b0c7b66509388d16d93a82faff4135348d179c881782"
    sha256 cellar: :any_skip_relocation, big_sur:        "652e29cc1744303744650f1a8783a19da326299a766fa729ed8eb5c4e7816305"
    sha256 cellar: :any_skip_relocation, catalina:       "99562938933598dceaa4126301e9249072739e5ca1b1ebc826e50378ee2a8009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01da2d5ba76c713765718ad7363da1f5e2e077b2f46a15a5f016273dc582c09b"
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
