class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  head "https://github.com/facebook/flow.git"

  stable do
    url "https://github.com/facebook/flow/archive/v0.48.0.tar.gz"
    sha256 "8772896075dc4028e62720fe18a6608f278f471931b2a8fff280d0efc0fd4f29"

    # Remove for > 0.48.0
    # Fix "Error: Some fatal warnings were triggered"
    # Upstream commit from 13 Jun 2017 "[PR] Disable all warnings for homebrew &
    # opam release builds"
    patch do
      url "https://github.com/facebook/flow/commit/9130d821d.patch"
      sha256 "acbe71d6f065390f86184827ada544840c9fdfa654bd0c81446b6fd5173002f4"
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
