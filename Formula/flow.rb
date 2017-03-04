class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.41.0.tar.gz"
  sha256 "e9169195126313e4576a7833eb1cdce50d94558b01fd92a0679c9f1dc5cbb3f1"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a453360b76c3b54636ce5fb9428a091b28f8ade57dfa3b0d4ef6e9267668411" => :sierra
    sha256 "03858f9be274ee06f586b0bc371f87d73a25c7b2897233334a273e1913334efa" => :el_capitan
    sha256 "ec61be440e6db1ee09e02c893ea1595d1e3877a264a62b71564557c43064af92" => :yosemite
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
