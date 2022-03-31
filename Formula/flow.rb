class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.175.0.tar.gz"
  sha256 "a0efca7d5b6227a4d0cb33ae2421d76afd243c7eb5b2d6d04ff100e04e9cc52e"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45cb08742f1ee81cdded08871d6a1e85d56a6c855fecacf1a674bd85dc7eaf13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "954663146eaf60d09ac43c0b5a3078f33b7e5652356ef730ce1d391f8b094dee"
    sha256 cellar: :any_skip_relocation, monterey:       "d5c38735bf46045f7a3e0686d8cc55fe0e5c0ddd6a14978af024fa8ccdafae84"
    sha256 cellar: :any_skip_relocation, big_sur:        "0503e35da74c10bf9144eded659dcb45e2a462aa9a14bbb56b8736e32c684288"
    sha256 cellar: :any_skip_relocation, catalina:       "312f2557f75fa9132e168ea9b6e4e7ce96e71d550e74908694d8fa527034c536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74a140d79a8c849d57e178a553c061161d6b668bcc80dec9d80ab03c298c102b"
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
