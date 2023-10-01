class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.217.0.tar.gz"
  sha256 "b57981191efaae03eeb96bdbbd5681548d62ade0922b0ce34d58b2548fbe08a2"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "004215d770bf84dee39896dc189d0a561716da178ca0c1fc756d39b168155c4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a1b312d2c3fa403fb41cf8c8dd69dc1da9bebda03c27b29213ddd047e7496a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8957aef0de540b9485136b26a39b797395878583320c57beddce4389fb6dde2"
    sha256 cellar: :any_skip_relocation, ventura:        "b0ab27af3dbaffc34762f5018d1614f9dd8139069710ec35d42c286d01ec36cb"
    sha256 cellar: :any_skip_relocation, monterey:       "e5da0336a126d3a8cae9c48a6baf0c296a468f38f9fd2b667b43f486dc9a3054"
    sha256 cellar: :any_skip_relocation, big_sur:        "eae22efa89c75df8f2a2b91c9776b76df0cd8b8ca79608967e7ea7c8419e4411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1362b61ed0d686ceb4915ba1184e4a6c35142f15da1fa562de3b7fb95431a79a"
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
