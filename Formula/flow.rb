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
    sha256 "23b4b46b55fe518d21cd1d4b54231a0f852a2befb09f93d09eaefdb27a09cbf8" => :el_capitan
    sha256 "528a730ddc7be062358cca49c8ca94e9b538b5e064de402414fafe2592aa486f" => :yosemite
    sha256 "8287c867a775cac61dce28075c27526a229b1df30f6c32d110cd726a60f13b57" => :mavericks
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
