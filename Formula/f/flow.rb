class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.299.0.tar.gz"
  sha256 "e404a8c833bc389d5d4a6ecc027211524a7428585e61bbab92e0ef422edad523"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddd8a58444dd248bc6fd9b65a71b5eb9618868f2ec2dc74d31b3cda9f1d6db47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3f664c7edc480de7e60fa6469b397379333771bd5a93f38b3b8a5dd023fee45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7d45e7dea2224feb2c233fc6e34b857995eafddc650cad58a721d7d5400a9b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cf17bf6657e5b9a1ca7ad60c76e8edffe83c1ddfb982d5b3c5ccf315bb9316b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab3c923945c66871651fa923895ea43dd79fa744a80a22649629ec0e1604acf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14212d54a587edcf917ea583be1f368b1bbef0f90cab1512f0463f7bcaef3985"
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
