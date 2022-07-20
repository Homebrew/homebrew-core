class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.183.0.tar.gz"
  sha256 "296288cbdf93fa78ed2bb8dc459f07ad30f838183af5f091879e98c1c81b035f"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a0363efc1c0fc6287a9ee4ceea5c7ac7ce8bf7ea274ebd903f26a76efc25fd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31f1c2e6d724ec685f1a822d940c528a7501d0c419e088710fd95ad92d1ffc5c"
    sha256 cellar: :any_skip_relocation, monterey:       "43d3c60fc494589fe0e0d75ac92d606fa0b94c436305aca13544282acbbbea46"
    sha256 cellar: :any_skip_relocation, big_sur:        "c68890edf41ad1dc57a06eb40a264cbe4f4ba340ed5aff0565b1d2579da2ce07"
    sha256 cellar: :any_skip_relocation, catalina:       "429df5741528f9c5a914969e8a487055e60b28da9691f8f4f6c025fb66b43169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94f35793edf12973c3acfad067daeebef28298749373fbb14d38592f0c22c701"
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
