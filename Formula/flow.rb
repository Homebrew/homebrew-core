class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.209.0.tar.gz"
  sha256 "c0f0b0b2e4f500c28ff32b290989a27e7238dd4d290644c21fe6c11bfad45667"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30847c8b8a3df3f1b3d1a7acfea8cbdc7f3cdbef7e4b7e275ee34ed75c81d14b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35310892f2feecbd62ebb3b5497bdacb57736942a770e50a30923cd8571b6955"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f79440f4de8bdc0ecebadd30c571451cd6c4053a96befb32452607cbe122a8c"
    sha256 cellar: :any_skip_relocation, ventura:        "bd15d5205991438534fb24c08e87d5f873f01db1db44c03eb8c162c1f7e98d2f"
    sha256 cellar: :any_skip_relocation, monterey:       "00065db6204a40597ede4a35cd123357c91212dcafac8480c19eae51ada2bd9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f81c47aff88cfbcaae316e2075e00a306ceab89b736b037b69a7206fe51642e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0fdb1c3e9289b08eb52faeb1d8fc88592dd31f70992f64960eeb7d3eeaf74d5"
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
