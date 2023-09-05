class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.215.1.tar.gz"
  sha256 "b5caca161db91df081e5c8e4e3782db8a0b888048a740a9fa78b6f1e6f5e6753"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bbdb2ba418a766d3822b156bebb1c4535e8079964ba10cbb9d34318702eeffc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "407b55a5e15199ef06b507fb66ed9763a584699bf9c2e6af57e7d28176daa9b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1834a33ca42c85252a1db9b4934a55c84a50c1d68f5a0f0a4a91ca8f0401d59"
    sha256 cellar: :any_skip_relocation, ventura:        "85a9c1dcde08437bcfc7f6943558473e82d2266b14471d0935af40f5938dbfba"
    sha256 cellar: :any_skip_relocation, monterey:       "58491bcafff913b5f81260e0cef010e104e4a1d9b7e75ee608700e509bb17c4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f65fbc8f1e67111ac4f1ceba625cfcf6173a8315e9eb303c2f47e43165f088e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4056705e238d6b1108d112b72b8eeb9a374f38b95d78a068651e5607c07d3da"
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
