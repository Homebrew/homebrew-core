class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.167.0.tar.gz"
  sha256 "48020fcdedf96f8fc5a150a0eb30625b005b1892425aa3c8fda0e2f38932ce05"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a0e553dbb82d8538ad14948c169d01365f9706435f68a817f0af796e64ca5b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac6ea8b78b75b0cae21f4c85be0a03f8b7fdf71c900b6f9d3a5d60c4c3b3472d"
    sha256 cellar: :any_skip_relocation, monterey:       "16999a25c097ca51902f4b3dae1d8794614dd467bff651587a236d1ae57467c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4b322618569984360ebf5608929663893de1a3fcf13b0c1ac10840bf3b6fd19"
    sha256 cellar: :any_skip_relocation, catalina:       "5fe9f7a34845a6c40cd34c4c35410c43eeb2fc5116cf911d3e7b2870c01b7942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d48449a79662023ceb656bbf9496568760c18ef1b6bfe75aa3c537f2ed8d0b7f"
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
