class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.70.0.tar.gz"
  sha256 "b3ed67553a45e57143a7c99e83bb9752ba670a081467140bc8bf92ca95887927"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f23df3ca8ff436c7843d02aec81b48a3369de2cd596b64d9494b6c53346e526" => :high_sierra
    sha256 "164fcd31ae674c02fff381e0a953b1d62d7911fdc749e5add6c1f02a9cec475b" => :sierra
    sha256 "8840575a72b0715f00232ffbd15abb9af87fdc80b23fb1d8178ed0249865dc59" => :el_capitan
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
