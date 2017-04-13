class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.44.0.tar.gz"
  sha256 "5c20a20c500e2a29dbe2b53ecc0c4a5172c849417c8bff32b2fa478703bf382f"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ba03442597ff1a708076775614d2acf48c8ac3cdbcc75e5521ec913f4a4a31d" => :sierra
    sha256 "4b409ae82c11ac9c4b02d3e30baf4c96450b845b5bb150a8ca9ccce5fba9f04d" => :el_capitan
    sha256 "887389517808321f04b109eaef595b36a7cb462e55764213c6d4455c68ec03d2" => :yosemite
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
