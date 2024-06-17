class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.238.0.tar.gz"
  sha256 "e1fb045fd9cc5c50424f2e6668b5cc58291f3d7f945d7cb7b3b0c14726f32a0f"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2444c2691f5c0aa4a38ce2e695b063dc0409f65e970f35940abee50cac65573c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bb85b78b13cf6042feddbcd4d8237cf8b5ddbcddafc8c0195f00a596d7a9568"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c57c9c9be96177eb8b365114bb34f57c16c0e367d95bb9b6afe94870cd45f943"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e3b5e3bf8681eab234235446ea496f8846a36ff9a54794214b9f2cb6949afcc"
    sha256 cellar: :any_skip_relocation, ventura:        "7670bfb83b36a6636c4a9925c19c1b8b596437ba356c554f73426cb66cbc9165"
    sha256 cellar: :any_skip_relocation, monterey:       "6a7d46ba2a7c1ec9a9cad4e16732329395392c360ca65a465a32665acb57f88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e6e4d5518ee41551d5de0e6602a6c3e3c94552f464c90f5a51e0c065533096a"
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
