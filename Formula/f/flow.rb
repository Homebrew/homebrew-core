class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.274.2.tar.gz"
  sha256 "910c4c6069e6df41ea676027d4ea3336fbf9e8454c8decdc1ab7cbd204337bc0"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ca1e0b170711721336b6fa04ac4799c294d0c1a616437276ceed2c4af265bb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1a895856942a1bfe206d1f764044f1eecacfc160b17225bd33ce3920d5f74b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09d489b3c1caa345b7050984ae77cc0ffdcbebb88771b08f5185868555152565"
    sha256 cellar: :any_skip_relocation, sonoma:        "71a8715ad44bcd4f69bb0acd765d3267a037a3e744c451de5b4f896bf93e4db4"
    sha256 cellar: :any_skip_relocation, ventura:       "e3ca66d2fdbdd0af154331c08447ef99e7ca4ea29b623074f189fa852812ab27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99b39dede06443997f8d79306b1097bf12130ebec25215edbc933916a942412b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84fc4a22ae9a0fc82ed87015ffc75d32e0d65c283e6d6e5e9e6eb38a0e93f9e5"
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
