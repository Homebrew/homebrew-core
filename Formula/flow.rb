class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.148.0.tar.gz"
  sha256 "77ff0623bcd48b276a633162c89fe719b931ff2111a204d97eef4bc5b1bb6e7d"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "4617d363d6b19ced297c2036bdc1c9d71b37fccb904d4cb5d3a89375fdb74abb"
    sha256 cellar: :any_skip_relocation, catalina: "ae76a599f9cc1bcf2f8bdb249a9347a9c488a987ac7ebe2e3a1aa24e9b3fb412"
    sha256 cellar: :any_skip_relocation, mojave:   "68677edaf1b704689b0a1e9d53a55e5b20fb163b362eab0569c55c730409d503"
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
