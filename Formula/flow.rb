class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.151.0.tar.gz"
  sha256 "127df81d3d79e18ef616aceceb6d05d78c8c00b13c89b895f7fae891e4910bcd"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "8578c2849321be922c8c3f6996e7de0a10f840dfe26f1ec53a3cad59f5f62126"
    sha256 cellar: :any_skip_relocation, catalina: "6abcdd48c4ede0fb4328d10ad38a03dd7a32919bf52d7b837300243a0971df5d"
    sha256 cellar: :any_skip_relocation, mojave:   "8e02299ef0b8c946edb113a5155c862218406b42a42d9bf219696cc3fdb27275"
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
