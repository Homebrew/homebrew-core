class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.182.0.tar.gz"
  sha256 "81240973cebc39ca912dc6061a9092a0aaab7a366780d2f9b4d3f9c699c921a9"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69666212dac8673c997e77c9fdc58c53b29f23228ff481a69699e4173ebf2228"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dae53e5c84e1d20173b255feffdd8c990185f59757e73991c12dd235d8718ba"
    sha256 cellar: :any_skip_relocation, monterey:       "5a3e19e8430a5912868f72a3e25cc9962d5cc26661c526c17bc8430a019b8719"
    sha256 cellar: :any_skip_relocation, big_sur:        "40081abe99af17b33f24e31265e5d2a685ebb8c3cbcfda7f91a30a349dc892a6"
    sha256 cellar: :any_skip_relocation, catalina:       "cc19848835770163e0b95b4514af0d374401756e0b59610b172d4644b588bb5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b43064fdc8be878d7617dd1b790664f091249850667b53b2f0c6dabfb21bbbd7"
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
