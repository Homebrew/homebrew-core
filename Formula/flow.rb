class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.174.0.tar.gz"
  sha256 "1f0387f7c6562afe2def2c358264a05101fffb25757d38060e9fc5f67ed0699a"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad1b73226ab387b301931570af830dc588218a024f2ddb102ae6af594d28594c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "000de9b7e8a08b542acffc9db88c667082213776746115ec0ee05b41b0c5eb0b"
    sha256 cellar: :any_skip_relocation, monterey:       "eeec95dbf4af4fefce2743a5d723567b59bccc77e0c79ddcc809d3c5280a7343"
    sha256 cellar: :any_skip_relocation, big_sur:        "abac39fc511eae4d0cc176c46790e29c77bca22ca8fb7968dc82c6fa57e4aba7"
    sha256 cellar: :any_skip_relocation, catalina:       "e2fa9114b75321c4b402c938c7c4f55030765acaed84e9ff96ce4ebec624a185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0594c88fcce3858ade16d39013d848ac8faa2179a8cec63e222c3864124d8907"
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
