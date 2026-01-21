class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.297.0.tar.gz"
  sha256 "c7ad06469ce658517207473f3177b41f44ce4bf0d79d5b634cf84012dc4d043c"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "024e603ff4aac76367102986b1822dc0a81f19bbe077e8931085fd84143ed5f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a1d89dab81896fa58b0c73e1d13e313129539ad6376ec50f797fb3b19fb4372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca84644948e633231f22130003fdb0f7015d8694f072a327c9f62d5dd5898be2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f846745bf9bd90ec219d233f4c41c9995c8d1a4733a06f1a69fbc6211b9b49f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6960603d611e30c1b9cdc8b671c7550b8353ea831dc4646a868e5e9f0b7092e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d50d8daf5d8e00cf9eb5e536580c145a2bd8b3865de26be48d73b57f42c2a77"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system bin/"flow", "init", testpath
    (testpath/"test.js").write <<~JS
      /* @flow */
      var x: string = 123;
    JS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
