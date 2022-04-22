class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.176.3.tar.gz"
  sha256 "a44d5d83dd1cf199350e1a95c70ad92a5e78be9d813e8456fb20af9e34d99b58"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf63ea66dce7e6b3dc7455fe656b03173d86f21486805b24f51fd920705e86f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3c5d584812518523f4cbd8eaef620e38043f2e4496630983cecba9de294ff2b"
    sha256 cellar: :any_skip_relocation, monterey:       "72b66202c4fef793878b041ddbc47b615e8e22cce40e7c17fde8514ea22e244e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a158682b57aedcd337c2ec5e049cfec8c9f24ab40968827f7ddaa62a76bfcb8"
    sha256 cellar: :any_skip_relocation, catalina:       "02bc4f9aaa74ca071e9d071691fee9a144179006d5ee8a4ba76de8b5c0abd6ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a6f066085d3c2400217f42b092a234f32f804fecde9d68a6f77e7657e8af5f7"
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
