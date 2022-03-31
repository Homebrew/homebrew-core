class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.175.0.tar.gz"
  sha256 "a0efca7d5b6227a4d0cb33ae2421d76afd243c7eb5b2d6d04ff100e04e9cc52e"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "713e3a69991c8a2578bf09d29b61e38a766a442c0c75992d0c244783be5e01e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "047703f2f8a357c884fe7f7c381a9176fc6d2bd67eee83ad18a6ee75e08df59f"
    sha256 cellar: :any_skip_relocation, monterey:       "535d5a10759f4619754c591617719a860090b5f5556748716fcb3399d6a743d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf122a9cf3e71b966c5e0898cf072a690d605cfa9bdc6cb9ca0792a98b2f63a9"
    sha256 cellar: :any_skip_relocation, catalina:       "6cd7b77521cb6a7bbb4922a68190bc4faf29fdfe79c022561d951d9c189e1aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84c1aa87a4f32123d4e5ddb349a4dcf76f3165b5f65e1258e2c126ecf0420f47"
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
