class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.107.0.tar.gz"
  sha256 "170b7c0b724361129fe642dc57d5e4ada7a9e37290ebb52e55b96407a2227334"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff27d72b84d9a94f1a39153cf2f330f474e9cf1d83aa91d650c9dbbb1f08b05a" => :mojave
    sha256 "8df5e001aa042564600ff419b65b3d96064f58a08da24e18e757659de147e65c" => :high_sierra
    sha256 "151b7dc02a8bdb14603a7bd32fdf0857e8c18da1b2f248e0545cd6def18c7ef0" => :sierra
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
