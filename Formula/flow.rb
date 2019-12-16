class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.114.0.tar.gz"
  sha256 "a165007b825b27725d8415040775fd641c7d5cc638c9cc048fd3b7773447abce"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9eb5a56233aa0bff088e6f300275e9c13eecbbac1ee954f003a209a2ecc4a332" => :catalina
    sha256 "3f1022b937bc559c3dbcaae6b5078bef357b1a9de449241d067b326e5c3ce016" => :mojave
    sha256 "c9e3e6eaf93ebf097895f3f09b83d39c38be5a99ffc8213f002e0bdc97946363" => :high_sierra
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
