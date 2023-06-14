class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.208.1.tar.gz"
  sha256 "95873c4fe348b337041c09cc8e490fdfd910a44a1ab7338bd703805931bb5a81"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "418cf04ce06d53f595a1ec62df34193d34129159e37b5812088652f35f605139"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "379522bad37a45f3e6af88d9a63d82d1142598c6ded44807a16aeffff0927eec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caea41d641e265c9e126e5d1d29ad44852c787ee84102ea84d14092b5c12ad23"
    sha256 cellar: :any_skip_relocation, ventura:        "ca4e3cf7cf0ece56878d0d086b008d88649b466b47f4be2ff758ec820d310907"
    sha256 cellar: :any_skip_relocation, monterey:       "6265fb96241da1104d8211373c175b043bc1d3bef685df9d732d7c1f7bddac13"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa92cb32647ce4de30abcadbf5dd5980c4a4b2a65e3a463432a3491b11926e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b01c5df28b742ada1cd7ce397779e02a94dddade0c6705df2b6e3261710286e"
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
