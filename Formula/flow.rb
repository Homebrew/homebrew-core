class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.44.0.tar.gz"
  sha256 "5c20a20c500e2a29dbe2b53ecc0c4a5172c849417c8bff32b2fa478703bf382f"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8873d2db250d862e4579c9f3a261f6dd65667846e6667e8b95cf31cf2df7dc5" => :sierra
    sha256 "717b9dd8a5464e4372e48cbdd13847d53f7ebc9e5ecd7559ff223976ee448fe6" => :el_capitan
    sha256 "b1b86c115c62464f5327e7cacd92711fc750d96a4aeb75b6a7d2e3cd55967ff8" => :yosemite
  end

  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build

  def install
    system "make"
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
