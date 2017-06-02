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
    sha256 "f3095c2f199c504791e8c17ad660565788b752b54dd6bbc916b9ab1b52c7ff80" => :sierra
    sha256 "4be6ed7a5bda5ce8d73d2631fc49eb73eafb2897f7543d04bc97a453d90f818f" => :el_capitan
    sha256 "10ff53fd8118aa86d38de9ebcec8ab380d7b740752a9ae77b0bc56c1d82c7730" => :yosemite
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
