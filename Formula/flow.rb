class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.43.0.tar.gz"
  sha256 "b8cbc5e8c8b4334b649608752ca17814612ba8c79fcbb9365cacf869a43b7f74"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac7b571d13d1b7d39fded83237433427e50bb1da6d8b17c3b74f0240eb8d8f2d" => :sierra
    sha256 "e39c4c102d6baf25ad902f1990c695e018800a328e82d543d4153ef2399a3dc9" => :el_capitan
    sha256 "1a5f3be9c629ca4d8e72104ead16c9f33276d6f9cc36683e5ab090d03b5862e4" => :yosemite
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
