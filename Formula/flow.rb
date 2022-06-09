class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.180.0.tar.gz"
  sha256 "a297cdf503852e2fbcfd2a23c354c39b89d0a74462b34a09c5f74c16ebc1f6d5"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47658a65108ddd15c569e92f1c9213999821c77fe1c8ae9fff5ca12a4b6b856c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "972d7225d30ccf00c16579ce054e2630a6ba85be9ca0a1d52445aa227553cde9"
    sha256 cellar: :any_skip_relocation, monterey:       "52888d9d852b22228dd41d1aa1d91623d1606c9a3cb40fda031147bea7acbc65"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3e105414af147ed5c806a56172732445002310f0609a6d028b07dcacdca595e"
    sha256 cellar: :any_skip_relocation, catalina:       "da4970d21e83a1a84e9a89eb9adfac807716730a96f04c4f3b5724c22e6a9113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24ba7c355ba4bb210ba678548cd830f3239cf23b7158a4abf90fb19501a492ba"
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
