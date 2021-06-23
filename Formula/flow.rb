class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.154.0.tar.gz"
  sha256 "f93b98e29968687d8405dc762d6b5fcf6825443ded5c9feba10898f667213bd9"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "ad8c8d4cd1977de2e4a36a9be0a5b47bee8def7f944168e352d0b8bac36c03f1"
    sha256 cellar: :any_skip_relocation, catalina: "27dd97b1395aef3ec23ee10d915a5931751ff854b4200ea4fe7d8488df03b9c5"
    sha256 cellar: :any_skip_relocation, mojave:   "d02fb1ef535f8fdc99c9da2e2bce657669d94ea2ed001faaa36f0c95f39ec9a6"
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
