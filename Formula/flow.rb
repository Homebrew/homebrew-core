class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.42.0.tar.gz"
  sha256 "5668a4a83242ac397239d001fbf071955a9e0a17ad255cb17b74345a434f7a93"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9115bbfe4a87e7cd605b33f70817a45efe4e11d36376dd4b6b06e1cea0a62083" => :sierra
    sha256 "a27d9d47a83919ed9b86fbba1d3b72c4db1cb930dbaa12299177c2e95969b7f8" => :el_capitan
    sha256 "6c331d278009dc497d4353ad0fd7054621bf0fab9a76e60c03b91e68aa4852b9" => :yosemite
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
