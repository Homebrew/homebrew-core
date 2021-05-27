class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.152.0.tar.gz"
  sha256 "1d05c8c97e947c6e171411af2dfe44ef18d756bf150792b86ff96a8249e0ca53"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "4e9cdf61d4f933628ed740b2aeb5959890fddac4e8d3d023d26c5d73febfbb4e"
    sha256 cellar: :any_skip_relocation, catalina: "37a9e43bfe073344dc5dedbe9e027f1cf574db4fd5905d8b310ce82e23fe1cfa"
    sha256 cellar: :any_skip_relocation, mojave:   "5704a5b36144a43e4074cbe41f4abcc0f41149b6ee8c358712e02d71ed8a5909"
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
