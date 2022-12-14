class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.196.0.tar.gz"
  sha256 "2411867377b38f0dee9d449f37abd1679ee89d4294005709aec6bda08c97e192"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10df433c1d3c515a36de5525c1dc324f0854c5b38514b7dfbac6877cd3e4c49b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5fc6900c21cc421984af725cf70208bcba8359ec5c1cc42e363d71457f37b1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a073146068ba916187e57b936cc0879315a71620f03d5d81dcca39f843c63f0d"
    sha256 cellar: :any_skip_relocation, ventura:        "dfc7f1e69584a3ad118c334af01a5f933e1b6d2f43e2f9cdb30799603105d87b"
    sha256 cellar: :any_skip_relocation, monterey:       "6ad07e2d6175d390b57b14a685f52adde4904f34ad040852ba1532fe26345240"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2f709956d2d8527035fdcb971ab6b39c0f59a876504b5870f846ccf96249ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29beabf5633973cc09a048d83fa4f89ce92d0dc0422be521b24d5bb9400669b5"
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
