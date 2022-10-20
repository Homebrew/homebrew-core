class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.190.0.tar.gz"
  sha256 "e55a07af4c9f6821954537e1046a5aff5bac61496dedcdea475376c24361b56a"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd8f741a842ec72fcd605e44c06870d4f0023d7819bed51c890acf1b4205b790"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4f00ddae99d5b8bd385c0386db83e3aa69a1bdfaf211d276a6bc7354ffd4068"
    sha256 cellar: :any_skip_relocation, monterey:       "2171e87dd2362e6e2d26bddaa24185cfb5e45c13f1807dacada3f2a7abd49d57"
    sha256 cellar: :any_skip_relocation, big_sur:        "313c5e4b25d61a944a8d8158f75a76b2c8f510c66af68cc5ee1ff1b93c674a48"
    sha256 cellar: :any_skip_relocation, catalina:       "154a0ad8aaede1a2e3e2a3d7ed7cbb50a492facac6fe172f67f916bb6820b688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b1ac361fe1a745872229b91334d5f2cb636179e2c36414f97b3a5f324d73b37"
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
