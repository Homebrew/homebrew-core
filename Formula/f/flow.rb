class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.311.0.tar.gz"
  sha256 "2b7963a9a72410e8521c514b7651cf7be67ea5bb0359756590abc5bea8b6493d"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9af700391fc1cb5fac4a7c0800fc63ce04b3905e43e524123b0d95fc54a30eec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11d728ff397cd2ad78d271d983191782c47aa1ec991d297dee928915f2c645a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15e1e25cc67085ca1aa4211c3b18db21e1e08caa589cb3ff6d976f1fcb86c1c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "00cc50d0c3031a79f21778077a69628b8c2630757e8e0af2655aabcb03a853f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cb24b1010163fdde0f5a5d8c222e7a7715e035fb4264de1b25b43d7d6bf0286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e86defc697b808333667d334df5399b5a20901f94df46fb3f4450dc4c513e5ac"
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
