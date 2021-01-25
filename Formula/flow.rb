class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.143.1.tar.gz"
  sha256 "06b7d39ea7dfad74dc56bbcf99124c27383a507f803c73cb989058fbcd990817"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed7591c2b30b994c4f03168784b97fcc2579302a23507e3e5ce5b0e9b757a43a" => :big_sur
    sha256 "d6357e19879492919b6fc7c9df110bed739cbb6e6d37e3fde151844989e1854b" => :catalina
    sha256 "48a9c385011270b810f1a1d8e95a79f0851ff336918451dd6cae43f37ecb1f2f" => :mojave
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

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
