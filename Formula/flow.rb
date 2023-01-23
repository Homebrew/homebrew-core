class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.198.1.tar.gz"
  sha256 "443aeccd76a9128b1d5b05782bf7a401269e7777d7d48ac9c8d27ca4794cd26c"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8459cd2a9880210a7f38dc7d63d41717aabd5d74c415851df1409bb70c577c83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48c7478aa62771ba3bf81a6eaf3e7feca720181993a35dff2d083f7cad8cdec1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0768da4ab98204eeec2828c93b4aca1dee8a6c06f6a79165a932278200eae75b"
    sha256 cellar: :any_skip_relocation, ventura:        "cea778829f82e1ec6aea08c5ad5d6927067a1a635694fcbe9a85a4f44280c371"
    sha256 cellar: :any_skip_relocation, monterey:       "59476a4b15841958a4ea9aab03bcab3b96e1d3e2b6cdb263fee747444b453043"
    sha256 cellar: :any_skip_relocation, big_sur:        "82dba4353b807133603740ef8bacd4037147dfe56ce4b5440729832f81b1eba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6139b2e45b823a0e039a95a8228425ff49896e4321e3327e0214233c409f2774"
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
