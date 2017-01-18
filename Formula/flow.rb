class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.38.0.tar.gz"
  sha256 "f21b56e10c1bddfe3d59da872e50d4013672a41f11a5d25d9dd67e494e8f1ae7"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e3d8de0fb7c5aced2e46867966be8d131a88023641a6d3dea024eb83fa9e43e" => :sierra
    sha256 "9e30a4eab41d150b10bc638f34f59295301c6514de6d1fb238074f3e3430a9dd" => :el_capitan
    sha256 "c16b894c3dc1f904044cc2ccfc21a652d12003ab1c65fef1f9db7be96253694d" => :yosemite
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
