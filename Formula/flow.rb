class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.171.0.tar.gz"
  sha256 "c519b150154e906d8f8ad54c1cd54665b4c7838a8ad9a5947089f4eaa3190f44"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "348f7198da3d3a7ed4f3ba612ee633234ff919fcb206a6e5f1b0ca533310657b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "356300bfcdac0bcf5ae8ce6953ccde9988b43a4ce780aec135a05ca62daf748f"
    sha256 cellar: :any_skip_relocation, monterey:       "abf882c9abda7198a35344d34212cfc6b9b083af216c10abe128d36e701f896b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0adc8a4f1035fc3370157407caacb6ea3e0ce93ffdf35a0322af3048a9796680"
    sha256 cellar: :any_skip_relocation, catalina:       "9555febfca374c78ca4946ec1ff2dc3e7cfd177205c15bddf12a4715928ee130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5a732b5308f527eea49f9a5c45a52eb3ecc630736368b548ebc784ee1e6d15b"
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
