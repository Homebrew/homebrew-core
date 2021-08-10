class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.157.0.tar.gz"
  sha256 "a57d5d1f043423252b469bdc1af8b4320563f9fa724ee1b7c506b8266319dbf0"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "77a5e150e85dd1c6da2bcf1d58221bc96345a4a1d65116f5682a433d22682f7b"
    sha256 cellar: :any_skip_relocation, catalina:     "815a9ad6189315a588727e25791c0df22cea1b23dab31b7d25d0198370028f19"
    sha256 cellar: :any_skip_relocation, mojave:       "e1205763f39399e491e266c604dbb76e3c532ce49b8108f93c540a70bf31899e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6961b5cd0869c53199e20b16dba9360c5d0e98e266b8e81f6b8b0192737e9aae"
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
