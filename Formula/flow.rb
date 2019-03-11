class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.94.0.tar.gz"
  sha256 "0620f6770665f8209d8a6c9e541b3a7dc29b3a1210130a581f5784820a16406d"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43be56c21af027d55eeecec5e27847a324dcc1b0b836c5c6749876d4061aa041" => :mojave
    sha256 "97246e5f806cfb5bf955ec4d5de385941f39963d9c97b113215f2f2dfe63e193" => :high_sierra
    sha256 "a457b6b15dd4b2eedbd2f1df7c03c935f9ee58c3355d29e21a6d20c2103958e9" => :sierra
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
