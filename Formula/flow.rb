class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.161.0.tar.gz"
  sha256 "df6cde19652387f82e0dbc12766ea8af83c64b69f6e5495531d1eee6d61a33ce"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a4b5b3b85872b71dac4b7d0c3ad1c60affdeec4abd052415bf524a3a552eff74"
    sha256 cellar: :any_skip_relocation, big_sur:       "c0e5aed264308227b37eb2e40ea09ac67acdbe2e2869b9fcc44b5a776de123ee"
    sha256 cellar: :any_skip_relocation, catalina:      "e5720a4d8bb642e2bfbab5f605f7d4fca4a74bf6668a12c904c2932629ff78d0"
    sha256 cellar: :any_skip_relocation, mojave:        "a374b19d73da6b3d60ec71edd489af627016345fb7b2cc6d71c530c07a2a3cbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a0ce1ea62662b62f2cdeb3f401692e633db3f055cc0ece80bb1958b6bfa1b8e"
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
