class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.157.0.tar.gz"
  sha256 "a57d5d1f043423252b469bdc1af8b4320563f9fa724ee1b7c506b8266319dbf0"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "c26ecd70d0fe6df293731626f2a8ae4d97069a4c34de1827033d161d2fc8fe00"
    sha256 cellar: :any_skip_relocation, catalina:     "9420bb0155f51b8b2b7ae2ddbdd3abf4bcc607056a06e6d7fc8e3f94e655507c"
    sha256 cellar: :any_skip_relocation, mojave:       "436a0f4c7c7c8bd7f29d1d6c8f2a5d56f667caf58e28837004ac296e9d1be882"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3565da8225ba82a8060737b432153efe1ee3a282e487278f5fba45c8857a7d31"
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
