class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.50.0.tar.gz"
  sha256 "859b6f5e1fce4d5813591fbc08e60605630d0b15e1825f877876ecd1476b8fdd"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb8ab317eabc3973db6f73fa0c0f442b8822d21498544fc5006b7523bb29a025" => :sierra
    sha256 "e04831e5e13e5813163202e0413276d000b5071c35c5769fcedad10b8ab9fedf" => :el_capitan
    sha256 "6188e72b8d64e858bfef19f013387aeeb3ee6dcac38c7b9b0c509e02e3098482" => :yosemite
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
