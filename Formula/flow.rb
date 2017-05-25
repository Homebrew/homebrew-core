class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  head "https://github.com/facebook/flow.git"

  stable do
    url "https://github.com/facebook/flow/archive/v0.47.0.tar.gz"
    sha256 "cf4bda660731c6d0731d1193fac458f590a1313172989b4a4561f64fbcc2cc1c"

    # Remove for > 0.47.0
    # [PR] Remove 4.04 ocaml version upper bound
    patch do
      url "https://github.com/facebook/flow/commit/e905086b3a1c2c35b6f204e422b8ce17ab6a4c10.patch"
      sha256 "02451e3213855ff984a2115db7d116f5924f59661182683e7b71c81b09f77b53"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8fdb2ad50afc0a82e5e8c14e099cfe67234e53773d7c08b0ce203518afae44ab" => :sierra
    sha256 "956e2e02b583fd4f92c0486752afca5012dc67b0b73edd9b580ecfd4746c889b" => :el_capitan
    sha256 "e751f655a7f23d7cfefe7a4421e6da008db8398661ba398916cfc405ff68eb4f" => :yosemite
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  def install
    system "make", "all-homebrew"

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
