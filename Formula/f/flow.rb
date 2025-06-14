class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.273.1.tar.gz"
  sha256 "f0444ff6c1f0c0f1acff72364c45839a817a695952cbd5d983bf0b122d18fcbc"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d30bb50478b8a899afc14a20ea364da6dcdf22286b615f2e513214a6e482d6c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f81d82051d94920692f3de6d023ee8da89db931d52872cb9610622b16191be63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2359d0b7715c796e71bb935a6ff61d2f536b43329bc5ade9d8567f863aa9d061"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3ef7c7e5807e243b3ec73f8c6c48dad3ba303b6a3fbb65176041e64ad88324f"
    sha256 cellar: :any_skip_relocation, ventura:       "f9d30e1dc94cf7a974bce0c387438226c1eaf1dbcbbcc326effa1af009413d31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d35774f57ddff697e9ab3d0846b8724c02aa4b717a3bda9ff5c197731f002e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "073fc0ba0110a0237e67c89bb7aac5c25c86190b41fbfffbd379c58490b129d1"
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
