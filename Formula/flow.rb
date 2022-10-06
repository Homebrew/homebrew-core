class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.188.1.tar.gz"
  sha256 "e569e5d2f0c818738166546494ff68ab3c0cabbd638eead1a70221cdc0d067e3"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83da69cf3a622afa8f3644c3cee993ac018a0a9195781d1abe6899f2b8e60e27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03b8275972c9a71287f825c5fdf3237ef9af34104cc0e82716fafb4197727acd"
    sha256 cellar: :any_skip_relocation, monterey:       "caada95c9452c3a90da1711f143e25edf6e04e493d8e5ab615b866e8a0a3e77b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b26a4b6df2a2f6fb4b059efe4603c73b3256ce47ccaeb42b6901a7f89f1cadc2"
    sha256 cellar: :any_skip_relocation, catalina:       "877f8221c94ef1d77ec53d96cec8e0512c0852ac13423a31811624e54585d9c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d67ffa770be84fc1a83fd7fb23997a9817f3b16cd8efedee1e2e55d79862efc9"
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
