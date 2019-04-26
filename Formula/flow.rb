class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.98.0.tar.gz"
  sha256 "a75cf4fb1fb0338a980a79cc42c76ea3b7bb33d0f2e55d676807250139d0c48d"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd0a83cc192d5ab7a8b629ead69c2c66b987c4e27b48c30712f9376b5b560d20" => :mojave
    sha256 "ec35f608d76f895db95d271074bd36c4bd9d9c9089859475bab369a64439dc9d" => :high_sierra
    sha256 "0bf3d18944d727a72e09d8fd8fa906fedf577e9e946e3e781e33850ec51fdb16" => :sierra
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
