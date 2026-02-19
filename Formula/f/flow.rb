class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.302.0.tar.gz"
  sha256 "7b329e0a21e7f41639de30640fba35cffbfba9c3fa717960e7bed0e27ec46143"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66bee7092c71d8ef4a16150ee95fdfcce59a4380abdb0e6f7ee6bf1d192ab3a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f2cec2c6cfc3696cad8a0fe59406463c8f916d986bccf3e34a57fdec22d454c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1164e8f12722015f829d7ea17e5d875ebfaa1e993e2dad7d61379a2a27292476"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e8b486a83b15249f75217dcea1a9d4fcd25062261649750d65b8b019610b1fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98901f5aa9c4de75753e633263a51c021c4515ba3e42a31a2932d50c6564c724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "789419db3fd551e5753ea465d72abc6b1c319b87c79e4db85a4d88f1d60398b2"
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
