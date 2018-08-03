class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.78.0.tar.gz"
  sha256 "f81d3ed44e36df33b561ed618432e45da51a92f19bd2e6ebe2abc19a976a69f4"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2d4019a08cb48f5c45aeb31967e56f68ef471bbc288e18ff428d0bf76498f72" => :high_sierra
    sha256 "db580f767098bece8c665da62da3793a9861ec5e00198f1354f8b76936e1b37b" => :sierra
    sha256 "ff85303887f4ff849994985766b613d98673109b5221179dbd3a22149c783aae" => :el_capitan
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
