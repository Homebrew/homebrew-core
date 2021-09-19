class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.160.0.tar.gz"
  sha256 "7cd378d87d31f375a8240a0b2dd8d323fd091c01a8f2ab8905377a6b282f8f0d"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "67131d6f214030926c54ddc489991418cee2a7f9469825c1dfdcfde251cd7b1d"
    sha256 cellar: :any_skip_relocation, big_sur:       "43fc2b499ad78a4b7769be2d55dd33ee31650018598820d27056d468ff05f9f5"
    sha256 cellar: :any_skip_relocation, catalina:      "92b7caa0e6a6a592961c99a0b47a623d41eaea3085cbf9a7f9ccb7e19e9a930f"
    sha256 cellar: :any_skip_relocation, mojave:        "bd2b01fa6b47cf2644e6943546c1ca61fa9986985a7bfc2ee6800d6f318bad33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4921357e4e413c4830d5e03f0abb8b12798916367d9c74f18522229b46ce616"
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
