class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.185.2.tar.gz"
  sha256 "1cdac9451720775943bdef577625c61d9b2bf639984c09f4087def0d0b7f01e7"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6075bd5180a2edf27983ab5da7abcda0f74654ea9bbdc4f3153631cbc05a8118"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddc727dd8be9e74e2fcfa294715828496cec2ca61c8abfe54f13437269c819c0"
    sha256 cellar: :any_skip_relocation, monterey:       "429e10d588765f9f1b2ff65e4ca5c6c7294c0a766ad88f76caf57277f7f72b26"
    sha256 cellar: :any_skip_relocation, big_sur:        "948522ca961083c35ed0c842d2e61bb9858d4d514424852226c91d1059b67330"
    sha256 cellar: :any_skip_relocation, catalina:       "967c2b8434150d065239581d9984ed2ddde3980a125434c885693a7d10dbf96a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fda0f30ccb561e59a7d4deb71a74923c68cfd2b88841137c9d614dfe051c9b6"
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
