class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.50.0.tar.gz"
  sha256 "859b6f5e1fce4d5813591fbc08e60605630d0b15e1825f877876ecd1476b8fdd"
  revision 1
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be808578209d85275c5034f124ed54880cb7117b670f317642fab61e71080114" => :sierra
    sha256 "8d4a44b5692074d71b8afa7936b6c87ce9b459d884a7dfc4a61219534f66b25d" => :el_capitan
    sha256 "5f3763ea5e7e48db979aebaf6e9ee29972afe29ae469805290091e61167fc57d" => :yosemite
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
