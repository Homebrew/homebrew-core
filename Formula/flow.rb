class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.31.0.tar.gz"
  sha256 "95e64a2ff6bd3c3c09eb4a7550f28275e9082aaa0999b6b54a413001c0a2c154"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "12f5125a531048c5baf902fe520bbb0f28de91c2af70752bd41dd9f4bc338aee" => :el_capitan
    sha256 "ac06d010e6930730dc408e2d5d97eae01db6d18835e31a295d5ba2746d469f61" => :yosemite
    sha256 "7e50e44e9ed0218c59a4e88d46419d7848818ff92a3d7ed0ff470a7082544d53" => :mavericks
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
