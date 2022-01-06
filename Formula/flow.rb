class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.169.0.tar.gz"
  sha256 "5323c16160285f3c257027178ccd4f4a7bea590eee93a84a0f1b9a75d3636310"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1c5b9eeb8493a23e53a6974ac97f8c4881aa16385a9cc39f8a0bc831c434e4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99b79173cb2f93f989c9828714b413e404435be5d8cc8c01cab85714d0f3810f"
    sha256 cellar: :any_skip_relocation, monterey:       "04e1e7d5a8bf7c5e2929662eeda343fca2b110a8103f3ea64d17227796888907"
    sha256 cellar: :any_skip_relocation, big_sur:        "e636e4985919ae32490b5b543b0fc06c4187fab60fc5befdee9a61b1b05b055f"
    sha256 cellar: :any_skip_relocation, catalina:       "62dfaec957fb7760bf5f96abf64c30c17a93beb975dd3dfbf650648f9b22e71d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "941bc95020f131c489d587068fa6b3f2635875f24cf049339ec7614335f1b7f0"
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
