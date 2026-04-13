class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.309.0.tar.gz"
  sha256 "b1e0a004f9c99721dc53facff8e06e6a59ddd5567b88a0315cb810fad1252341"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "962026760ead944f7f6baa1ad92731bb960042690c0b05a52ff9d92510294ca8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "909536947b6dc96343ebcb5d1700a4b652d04736b1bb755cc05c66cc9da193b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4254116f610d819f7d016c5b228895828cd22f952ae39a7e825e1c1a8fc43fcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "48be6c47ff6efadfda85f5242a835e7915cf78b6ab49d82d176591d23080ffc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc8079f16218f18b00e5cd1a9334f8d14d38494ea5d2f68c49bb91b4c7cb8811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9d15490408d821b00b17a14c768dfe2f0041530866e2556afd107b926fbdbc9"
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
