class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.227.0.tar.gz"
  sha256 "543391e26c1a0d27f119b087ed8075e6da0b54c49bda58b7fc5c07dcd61134ad"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72b037706647b6c2d224921eebc96b7c5773d81888895a6d37a40f7d2b201c47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbe4a2cf58349375d0417a0a6c5c946d86e73ad611221c3a4ce257f4200a19bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46690bfbff76d472036dab59eeb811f91f6e0040ab33a1708e05a0aee895556a"
    sha256 cellar: :any_skip_relocation, sonoma:         "30f420afa3a36ceb17b432b2d8e4b6f8ab1efbb6e55d6d796993d118d18c8075"
    sha256 cellar: :any_skip_relocation, ventura:        "2f6a9f0a923cc78f897b7b0887e08f66e6227724b8cc12665b49d4d74fa7e6ee"
    sha256 cellar: :any_skip_relocation, monterey:       "decc8011e439baf507057c8b88551e3c5fc759019b143a2a8e9b722dc35e562e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8470f65a3a94f776bea6e35d7cb3be6b9ee7405f93f43202f9ef739f1da3d82c"
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
