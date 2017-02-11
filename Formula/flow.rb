class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.39.0.tar.gz"
  sha256 "67308fcbfa2fc28996636a1be4d1b060c679af1fb570395243ada8a3d4a2ca48"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6480e0b90809c744355b92c9a213844dee36547bd6176bba4c07d800d40de55" => :sierra
    sha256 "067501061316fbc042af8dbe0dec78b83d34e05a58cfae8152e2557aaae0860a" => :el_capitan
    sha256 "94d3e67a84e639bd7cdcafbf16b631566ebe769f62b3bd3f3a68b6550750a58d" => :yosemite
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
