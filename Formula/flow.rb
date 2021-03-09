class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.146.0.tar.gz"
  sha256 "7221c17e56511ed7ed3770c04f8aa193d841c19dbba70737b4c89f45d094179d"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "51bfd42347569c751e3d89a32767436c8bc716977d0d3acf53c2062dd9103d46"
    sha256 cellar: :any_skip_relocation, catalina: "5616d2acec5a9d75b31177454c3c74afa19017530cde7acbce6de9a1c6f0bab0"
    sha256 cellar: :any_skip_relocation, mojave:   "78a8ac6263b7511a6e11a5bcc88106fff57ae1251ea52ea907e0f5e951c87701"
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
