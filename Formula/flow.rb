class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.101.1.tar.gz"
  sha256 "15d56143ddc3fa69ec1105ea6b48282518b115ce1286c60b40b81d73637d27df"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3740f784470a36ab86a749e8f10c8bc0eaed771bfcbb05048681a1cd8ae04e4b" => :mojave
    sha256 "2982e386fa545cd33c13f842d24061457d760197e44a918716da99747369c23f" => :high_sierra
    sha256 "0d45cacd1f80c83001c703025308b3dfe77e8c777626d21824b9f0832bc0a555" => :sierra
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
