class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.191.0.tar.gz"
  sha256 "6dc6f294b4df1a53dfc04f6cb2bce77c6dfc7b80dd3e068cd6c0fad863d4fbf6"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28ea0a04aeb7dab13583004d3ad1d3de99aa0b30f1e4c5247fb43f7b0b367436"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01162c72f84230451229d2af34207edd96465e3172e1a1822b6c043ffcf7acc0"
    sha256 cellar: :any_skip_relocation, monterey:       "e4c2272f7a5338b0a31bef985416dbcf61e95c500bbd6955fab2721a557da4d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "37cf11fa925f926b2d4fc4551888afb8c073a2b2331faa8be62c9aa508d1d202"
    sha256 cellar: :any_skip_relocation, catalina:       "3ce9676a01898955b6c399eed87706031373453231bb9792c4b152993d3268bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73dbeb7590d884fe4ddc4a4ade348ef4bbc52c9fba2318b55df0ec7ab95dbff5"
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
