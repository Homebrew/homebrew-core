class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.106.2.tar.gz"
  sha256 "f70a1874b7bdbcafea8e5828b21ebfe64e53fd5c4470ea8b42d99d1eb942f44d"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c00a34f69c15fce778d1cea0c56aff50833c27cde67c9fa4ff02158d5066ce77" => :mojave
    sha256 "daf382ef033e67f46548c8976e1e41edc43ce77a90d8f349e95a9305be1899bf" => :high_sierra
    sha256 "88a409f26d1a55622ccd9a71a2f32b90f7c2c690799a20fb3d0ca3c71f4f1840" => :sierra
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
