class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.171.0.tar.gz"
  sha256 "c519b150154e906d8f8ad54c1cd54665b4c7838a8ad9a5947089f4eaa3190f44"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "527de771df6b9f8c357da0f930b8f55c7680832537f0cdcc701c44befbd554e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78876ae5fdd74c75dae03b7e68e99886ec19e381970f34a40061a04d1f101d02"
    sha256 cellar: :any_skip_relocation, monterey:       "1e4d22487cc7ac37512a780444f9095a75e7abd4748ff08b3e200ce92edef60a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ec9bd6dbe61f758bb80b32ce884de8e91391508a4728098b8372df14035cfa8"
    sha256 cellar: :any_skip_relocation, catalina:       "dbde5ed238758fd0d492acc0f6b241861232d1e70bb2d90585698958231672ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3383a80c12286ee625b783e8f61d2ca27cfdcbdd7354f7f24256c523ebf3d8f8"
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
