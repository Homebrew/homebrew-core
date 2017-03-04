class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.41.0.tar.gz"
  sha256 "e9169195126313e4576a7833eb1cdce50d94558b01fd92a0679c9f1dc5cbb3f1"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a195bd1d682605d6099851e45af11bfe2a947fdc7c13915dcfebe8cd78725117" => :sierra
    sha256 "be03a1141531008a5a574b48a3c2487d44bb4f2c638964f19be09a27a95b0b51" => :el_capitan
    sha256 "a71e21534c9d52d54e0d3b921002f179e1ed76b91a25387a49844ca6167a6050" => :yosemite
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
