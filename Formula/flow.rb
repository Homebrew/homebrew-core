class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  # Switch back to archive tarball when possible.
  # https://github.com/facebook/flow/issues/1981
  url "https://github.com/facebook/flow.git",
    :tag => "v0.27.0",
    :revision => "ceea4c3616824b9ad7cd7028dece2d55a7f3b539"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "83cddee9525e8810e97160e958e09fc13e735b30448b8e1e72061471b12c53eb" => :el_capitan
    sha256 "48e7c2e249636cdbbd4a4d139cc6c7dfa65517f9eade2709b9e6c122a02e3304" => :yosemite
    sha256 "5aafcd68ff667669cd0e3f10be44d6e83855ab1b7cb112853831295a6cfcc970" => :mavericks
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
    expected = /number\nThis type is incompatible with\n.*string\n\nFound 1 error/
    assert_match expected, shell_output("#{bin}/flow check --old-output-format #{testpath}", 2)
  end
end
