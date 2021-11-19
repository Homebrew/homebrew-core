class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.165.1.tar.gz"
  sha256 "8750e7f6c8b9c05d317a4c9bc3d9bf33a575c27aa0e1c1eb99f7e5378cd55108"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e48860811fa6c1a285e99ac7088c6b65099b3edb3c9e131732f5e433893b9c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24bcc5365398e151bdf46a6ff59eb76735e53e23b5857fc8ee21ad791f740463"
    sha256 cellar: :any_skip_relocation, monterey:       "69c63121b2dcbd9344f78bd2734d2f5c12f418c3969df258c9fb1559d90730b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6402c03eb262fe603f3ccb666c3a4a2fa266ffd302c67596786d41a0e96f3929"
    sha256 cellar: :any_skip_relocation, catalina:       "08ed15d9d78e5dbfcc72cfe9e78cc7b30264fd35b4631863255a848c5c495cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a65e9787c5aada3aeb864dc4d99005f19d1cde13aae53ae9db01b50157fda255"
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
