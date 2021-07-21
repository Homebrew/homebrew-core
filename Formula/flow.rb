class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.156.0.tar.gz"
  sha256 "b5f0730e9ba2d6669c6c30515a8db659643771d0a97401eb7fb57b7921bce90c"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "221c2b193607e01b91e9412c844ca1881c4e1d556d40f55e363971d25e84b8c3"
    sha256 cellar: :any_skip_relocation, catalina:     "7545ac181f725ec8a9a99b3100c6b094943f90b003b5098647d61759102636d0"
    sha256 cellar: :any_skip_relocation, mojave:       "28abc0358c09040042064f3b0824157a7f4b78e1242d616e9de97337d2048cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e67e88b04f8707b4fbc2b0e1c3c20dcf8162df8caeeb95f811d2c5ed0121f747"
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
