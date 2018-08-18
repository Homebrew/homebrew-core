class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.79.1.tar.gz"
  sha256 "8e0057376270ac421a6f06ee026c00c286b82ac2c770520c410cae916e7dad01"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1adca4ae34e93a649946153f4dc7562a3915fc7fb22ff817e020e716fb0c880" => :high_sierra
    sha256 "72528fa1ab58593476c85c30556293e6cccc9e6d555d8d52ca277117cbfefb5f" => :sierra
    sha256 "92b91778d1ca773be0cc409714e9cdf60b6d8422539053780eb2c8f24499fcb2" => :el_capitan
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

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
