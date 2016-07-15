class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.29.0.tar.gz"
  sha256 "146289061d01b962519804622a6f400a72f48ff5b813c9b9c097a6bdff9237be"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce0112dee8a946230f8e04fb60b51f044a42b4766feb50a0adf7444fc73df155" => :el_capitan
    sha256 "c3cf5454e8b01e150ff3e8ce4ad0b1b7678324278ef41cb4b7b403a21b6f4e83" => :yosemite
    sha256 "40dd5e1c8eac0e7663d0f3b7a925b337cf174a4c9aebcd3c5f040fe6828357c1" => :mavericks
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
