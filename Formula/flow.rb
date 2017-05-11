class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.46.0.tar.gz"
  sha256 "f6991604d95285c0944cab4b1b075facae53a4dd59bd836ee24cacd7f85b42a7"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d18214fdc02524e872422e38391f67eca3923a5ae8c92ca7b19e053aaa853128" => :sierra
    sha256 "ed10e631f87e8316d3473719fd15761da02e79993cd04617545226acbdd6a899" => :el_capitan
    sha256 "9add8e39f9ee1c20e904043a64ca9b2dc62e0b907be3bb8a3055f3321b3b810f" => :yosemite
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
    (testpath/"test.js").write <<-EOS.undent
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
