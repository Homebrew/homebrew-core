class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.100.0.tar.gz"
  sha256 "cc4e3883f8b588cb3456901379c3bbd36a104bc56a8cbbc5936350953153ba33"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9752993305fe730ad085aaac03213623f799d885cc726f448d0b955191b026f" => :mojave
    sha256 "3967eabd3a2c91fdbafe288483b050dbed128a0754196fe83e677dba718a494c" => :high_sierra
    sha256 "344e9fb3896dfb36bc694710c51f6f88292380edac56b712040733a52cc479d6" => :sierra
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

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
