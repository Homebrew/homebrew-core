class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.24.0.tar.gz"
  sha256 "183c491bb207b084c75a6752ed4527a71e09bcbcb8ce2fd2bb198d496e4016c7"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6bbb29a3ed8f28d77eed720f05145b2db2878432ad3553eac1a1851a60dcc70c" => :el_capitan
    sha256 "ca98cb55b055327f2d20a80fc052c1b0d7f897905bed5989b6c81abd512dd6c7" => :yosemite
    sha256 "9be398acea631fef6cfc374a7f58b8065d7a3bc232680a4dafb6ea3c1cea937a" => :mavericks
  end

  depends_on "ocaml" => :build

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
