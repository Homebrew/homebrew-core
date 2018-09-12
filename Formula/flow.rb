class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.80.0.tar.gz"
  sha256 "d596e297c771e88172c780a062121e6d43fce4b435290c1668fe3a91e421acf2"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e9d8a8a2dbb04159ec8caaa7b1d8c4d7be77a92d2465191d404c95cc0b5a58e" => :mojave
    sha256 "21c1f08b2ad83b5656834a773bf54a38670c6f026c14bcf99ee8b7d757e78b68" => :high_sierra
    sha256 "1ac7fdbb70060e70aa89e36a3425645710149e67f56ed28e2403212b84c28fee" => :sierra
    sha256 "413cf7f4ab1b102c7cbceb75407bab73c71340672aa7167cd8e689e4d540ca12" => :el_capitan
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
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
