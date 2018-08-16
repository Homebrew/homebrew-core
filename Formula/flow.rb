class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.79.0.tar.gz"
  sha256 "79f53225540d0f6cd5a908e772127426bb857001907bc1ff8a1e0ac12a310257"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "823d2985153026624d2513fd5b1da3fda1ce5ef22aa93a5be13dded46df31743" => :high_sierra
    sha256 "9ef77c602d075a629242e658728b30f560a5ff27f3386953aa2360d608815d78" => :sierra
    sha256 "507622ee800f33d9ca8ccd031855d1643f024f09af948cdda0e74cdbee233e6d" => :el_capitan
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
