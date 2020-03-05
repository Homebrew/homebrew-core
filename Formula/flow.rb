class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.120.1.tar.gz"
  sha256 "46641dac3a5ac3579085cfdfbdb336daf8432d35e3e51cad5963d2fa06286dd8"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e1947e611ddf852c831740b1551c99c06b1fb28ba9981a10c70f54c1ad8160c" => :catalina
    sha256 "b42f0380d496ab62b0da44f9844d38ba8cd4b38a47a18aa1d31c73532c702af3" => :mojave
    sha256 "991c4d44500b965fda29e536b692a98661c75e6e789ced69c11e1068bc2f3332" => :high_sierra
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
