class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.268.0.tar.gz"
  sha256 "1b0398c6fca956b0b049af3e8cbac6e6f401bc467e67eff42cc2ee94b250ba7e"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec745d574decfa38068d8a8ff1443c9d3b7b0477a0f0c91e03e77b7c885d6456"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83575915a7e58ed6bb2df0b87ac243ebe210872e12ee1435484b8adbcc94ce63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "791fcc000d6f21e8ec05bf52b2155b76cca53054465afb3247beabf510a572c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cedd167d44532f44d1b6cb96f615a28acdcac312141249a22dbb223c5bfa0ef"
    sha256 cellar: :any_skip_relocation, ventura:       "778d8e7ceefaf0b04e043376c0da36132d5dd0c8eb0ccedec5221c89e6decdd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9b1ff08eeb167f702b477c9c866c21005133a3267bfbf725b4f8838d305f685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ea8923b5d4b8020ecd77357f7f1901dd64a4ae1e2c0bd9ea74726532214368c"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system bin/"flow", "init", testpath
    (testpath/"test.js").write <<~JS
      /* @flow */
      var x: string = 123;
    JS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
