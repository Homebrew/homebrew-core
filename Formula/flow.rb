class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.195.1.tar.gz"
  sha256 "e6663464d15a1ff2b2beefe3d601c02e72efee03bf70f41b6bb5a5d4c9e998ee"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3a83bd81cceb9a471c5d5313842c869f11514508a82b0b33912df283f1406ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "643329d577128b3108602ad6d7d8eaf1649c99c0c7f3db72caf1c0e29ee77020"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca6afb09827daa80db544a2d9e3d4475befb7b5077bbec7095fda51e2d63d912"
    sha256 cellar: :any_skip_relocation, ventura:        "d0383941444ba308eea5ef293c14d4a556fb6f3c7233616e787f811d40db81c3"
    sha256 cellar: :any_skip_relocation, monterey:       "31fca0a732bec02b00778cf357a7f8bd31cf4575e03a2c36e89a90b7e5d366ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "6777c2804e5c4610ddf03ef4809663cd8a072187e47b87681b40d2bfc705c6bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "235f60b91e103dc70183ca40ff8ebb2f83c8855ac0f852bdf41cfc78b676800c"
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
