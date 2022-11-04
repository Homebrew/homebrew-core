class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/0.192.0.tar.gz"
  sha256 "9f25df2a6cad6d70110f41faf760c64844f052e43119332c3b3d7c133708cfb8"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b208d3923d7bba4435edc9ae7bec31b872a63b03e65bae94af00599c3764f8d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7564a437001918595dad7963bf0e2eb33a2dfd024497d27b4c48d6addb20da42"
    sha256 cellar: :any_skip_relocation, monterey:       "528804c33cd88ca4b1a600e4e61405a5407c29c9c99d68e6e6cbf02c1ce49370"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea5da3dc9d8b17ed68c05d85bcfb37cbb7e959559467f4a6fc67c92fad67bf6b"
    sha256 cellar: :any_skip_relocation, catalina:       "94ce2341411fec28e1fdd490c371149d79dfbe2fb4c835899309e1e90a57f416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1811d6d6404291668c2b699eea52424d0e7f6cfbb5f991028288164c2c00174"
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
