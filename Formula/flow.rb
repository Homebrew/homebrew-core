class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.198.0.tar.gz"
  sha256 "d0bac6ce60002c44dba830458a6e9ece7edc1105e706dd1b46202077b4d73246"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acc32f819578922f67b14b8f0a6e1fb15cfbd2cb7f2e428cb9a33222568ec94a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e63314d21849e8f9dfd1e12806603a1cc5f88570f239c83fd92ba55e46222205"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41ed7ba616828582410c8375871ea2b14c78fc153220e327b183c0143d2f9133"
    sha256 cellar: :any_skip_relocation, ventura:        "a3e798ab10d219ba87b5b875cfb66c10d79d8c47567a687f41864a68357593d5"
    sha256 cellar: :any_skip_relocation, monterey:       "494c1a449e685531b7f025dde3d1324519772a9e5490a7f6326544f37b011656"
    sha256 cellar: :any_skip_relocation, big_sur:        "644cc7015d532f60762d1e15df53f65162843961810b28d78e93e7eeddee1aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b66a7003f2982cb730cd4db1a2e5c2ca2386e3e585011be4470e6821d077923f"
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
