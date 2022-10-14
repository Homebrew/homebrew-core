class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.190.0.tar.gz"
  sha256 "e55a07af4c9f6821954537e1046a5aff5bac61496dedcdea475376c24361b56a"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e54782176c643e3fff94b06fe5eda618b7be14a2ef22d3911f60afc3510e417"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f7779f82438fa66e00c751846d226f415105d1edaaa619f74de27ac38c2648e"
    sha256 cellar: :any_skip_relocation, monterey:       "e6d7c705ee6d57aa1179bdef90e09667e6963235721efaacb0d55a30d1cb478e"
    sha256 cellar: :any_skip_relocation, big_sur:        "40663628e61103835356729850bc0e26a17b7897243a21bd32e041ca8f79949e"
    sha256 cellar: :any_skip_relocation, catalina:       "8f0dceba32b5f94d438211fdcc9f1062ee99b1e43d5062a319cf3ada646a03eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68dc6622661281948582b581f096369eb80a54b2d12150f8efbddaec8fb0d9cb"
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
