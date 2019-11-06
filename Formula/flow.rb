class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.111.3.tar.gz"
  sha256 "4781a644f7059f994d0c1f73c509e25bbc72a1d9dcbb0fbeffaeb1a1896c1b86"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c46a5b5b799e388091a62cc475afc3acca83f71a9dffd2f87780d4b2ebbbdbfe" => :catalina
    sha256 "f81c82cadd1cb6684946c9cfba576f8e2b67f92ff0951a10de64dd8c2cf8dddf" => :mojave
    sha256 "1cfc8a52a3440b3607f73f9eb4cb4544db440bd1ca85936c565d61e693258075" => :high_sierra
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
