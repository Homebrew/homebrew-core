class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.186.0.tar.gz"
  sha256 "50ba93e8b6ef1329d399093930c69b79995a68bbe348ecead14dc4aa66cefe24"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2813236371c713695c7564350b8c936c3f0fdf8c96c0aa84350c774348473f23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85eb0df372e99280efc5e696b5a954ec3a7fdeb19ece426a9f4a734a228a9d27"
    sha256 cellar: :any_skip_relocation, monterey:       "e85f6531ea2a0a54e9d9f87bf9323700bce99f6ef3172b98327b2af0757a8fcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "071b4fbed54c2ebbd3f62766752861f5c8c00de2067ee39accb63ac8140ce648"
    sha256 cellar: :any_skip_relocation, catalina:       "99f75be5f4427e31e3d021728043c771a7662ccdae8f072111c0979a3281ddaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78534ee84a15a7bf01ff4274420f0bf22816a21ab108fc64f0d7b578c8f97d45"
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
