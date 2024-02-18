class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.229.0.tar.gz"
  sha256 "846a25edd19e72dfa4bf2844e0c8fdc2f5e3be4f2db115fc1385ddf93e515c6f"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1be07b04979bc57bc5247b93fe538405ad04b0f719db39496bb27168bbac5506"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "241de90b997aeaf1478c0b693e1c1ef900e77e48b99a5e637fd4873f8f52b891"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5301f438be656ffe976bde24058df20fd87b6c7548eac84762bef46c884face"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f9bd48a6531c3e5924042c4fe45cdff5118daa1b7d4964f58fb217b58835056"
    sha256 cellar: :any_skip_relocation, ventura:        "12fdf539a3a4a0c013f3fc5b6e41d3949ef8d5477d0a616f19aba07ff3a1e43e"
    sha256 cellar: :any_skip_relocation, monterey:       "0a47437ae1dccd5fdc7da5c59dfe0182c9364a35e28e1fb427b3613f366283f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8f4cd7a3d47f31936aaf33335b9f4df5801e7124ebbf3c66775282d0b032f3f"
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
