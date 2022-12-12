class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.195.2.tar.gz"
  sha256 "3e425f39b068bb7dd1a40a1941346e60fe71ee1fb02334da72c3b21f7a797361"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "376a7ca3f57be4013615373eb84ad2adc3da147a10c6379e1823861449833990"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a187feb02eda471ce51accf0554db928ef9fc37ad0400b16de38d21a57e1e1d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eafd489b463ee1e211bf900079825c37027c777877e722c291e7da0649cd685d"
    sha256 cellar: :any_skip_relocation, ventura:        "6dc370ea3bf685c4db83f0b8adcb43ab0a72f14bc7e5725df8ab2c53c0597f90"
    sha256 cellar: :any_skip_relocation, monterey:       "54cc4db46f1962b91f2884f1773c36763a0f778ef46e2d85059658f22d2a8385"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d6659d7c3ac6acda56aa3643befee9499b76319c23ca8390d2c0fcaf3f2a93d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6121e22615d9b5ae69696e6402e071f73fffc5f5d6fdc9244f43716e398c9e22"
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
