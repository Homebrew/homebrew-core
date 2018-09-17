class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.81.0.tar.gz"
  sha256 "aafde40834a5727911a86cd3500bb7e661065a4c9895490faaab2222fffd4274"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "242db8630d5c3a18371647f3a97c1319a7e894768c5077d3a626b5aa83f19012" => :mojave
    sha256 "b4af4992b829c59e62bf3d51c7d8640112811a75b4aa32f95356e0488e2d8e0d" => :high_sierra
    sha256 "b842fb5254a5f7c6331a6a55a5749df738af1487d15f46acdd9e1f76f02f8645" => :sierra
    sha256 "423c871790bfbb0c27ef9c0a1325050a40225c235ed23049b0f7a5dfbb154ea0" => :el_capitan
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
