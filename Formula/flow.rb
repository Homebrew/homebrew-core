class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.36.0.tar.gz"
  sha256 "064792468e9b811fbc8d030de18b5b296b6214b2429e6c40876a64262e65fb16"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3b1c08c1758d0476596e0b7337bba58be075856b440fcf37c5eb0b4ae4897c5" => :sierra
    sha256 "f10d2ba2f8efbf505daf76a84701a069293e5a13d183caaa235cb8431a1c49fc" => :el_capitan
    sha256 "092d894c008f4fbc1f8157208c87eedd88b8d1cf3d3c619755915b82032165d8" => :yosemite
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
