class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.202.0.tar.gz"
  sha256 "d528d7b5fc4f086a242d8e49a7b791c99b18b24cadc71e10c7321c7fc7583447"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a5e5e59b1b5d3e74aa08224e044ff5b8a0debf13a8af90c03256d3b2a9c5cb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f71f6207f414d2d5b1386b25893ca6b8a0f2c3bc8b666a9764f19f4c755faa81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e23f5617d609b1c98f8abb23fd03af0abebdf33d38f81a21dc2fbb2a41a08fa7"
    sha256 cellar: :any_skip_relocation, ventura:        "d25a12d36dc15d9365928087ab04950c7a425a1c8479bf63674865a0a73ce4ef"
    sha256 cellar: :any_skip_relocation, monterey:       "021c9b9a07272e337ccb588a6099d3ee40f3d06494b28a2c277cd28ca3e912cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc48bb5f42f092b71201fe6fe8d6c55ddf6f578d79905b81618bdf8e510295e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c2caab6b08cc74ef107ccc1c835da2aeaf4941084e787a813be8e55534bd1b7"
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
