class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  revision 1
  head "https://github.com/facebook/flow.git"

  stable do
    url "https://github.com/facebook/flow/archive/v0.36.0.tar.gz"
    sha256 "064792468e9b811fbc8d030de18b5b296b6214b2429e6c40876a64262e65fb16"

    # OCaml 4.04.0 compatibility
    # Upstream commit from 22 Nov 2016 "Remove unused modules"
    patch do
      url "https://github.com/facebook/flow/commit/2edc619.patch"
      sha256 "6cc507f72850e1ef921e7db2e9ac5a036851f23eca00c00a14c9bfbb77b5eb1c"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b7e9a3011c05ceb26b20c590746441816ac9697453c98d7ff40157da42ef31ec" => :sierra
    sha256 "09b1cd562b32b5e4776ce063bac3053c02afabffcb3dc9f4270d266cd28850a7" => :el_capitan
    sha256 "96ab80b672aa81a15e6ff736e5bfae4db30923c72a5acb17c76ba18c8dbf48eb" => :yosemite
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
