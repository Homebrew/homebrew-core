class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.155.0.tar.gz"
  sha256 "020e3a02e959f6b13263e43af899f2896a16a389650946dfd5b82c02c9bdea83"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "b6d37a8d19e0ce69439842cddbe0c700e3297902291bb6cf8ed90929b14bd2d7"
    sha256 cellar: :any_skip_relocation, catalina: "6f455788f09ffdc518ccead488cdce05aa7559112085f2d2dac18b9ee6e44da0"
    sha256 cellar: :any_skip_relocation, mojave:   "215a672a9f61e025260b360df9f23b5edeff93aa25138566de8af4dacf798dc4"
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
