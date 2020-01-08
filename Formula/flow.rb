class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.115.0.tar.gz"
  sha256 "ee0a2dfa80492dd208d7bcce3b5699450c84745b3f434904c7e99fd1eb70e7cc"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af3bd1caf20176cd5f6ddf3e1f9044174e2ef6b7445dafa9e1ddbcc56479667f" => :catalina
    sha256 "09ec194cc6b4283f6d4595ae93b5315bb0d581975a293851d95ed1789294d99f" => :mojave
    sha256 "7cb589de45a81ee471a61540c3f8ddbdd9a9bc8b010cdad3796c7c37081870b8" => :high_sierra
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
