class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.164.0.tar.gz"
  sha256 "675f1da86b9c39482cd6d396fc60babebcd9ac80ff3e6ad94f9be2e648b288a8"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7dff924512c0d5e8d69988aa7a1c6d719def7512751df49edc5c8342fbcde4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44e53b454e64c744a661c2f78f639f30df8a422298d01a51687685cd96853825"
    sha256 cellar: :any_skip_relocation, monterey:       "e20dbb70eae0b120f507b06c401939eb63cb879a8c9ce71c240148b73820f5fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2b79e1de9758410916ba2264ed728ae664276975de01042b4d1323f9ad3b220"
    sha256 cellar: :any_skip_relocation, catalina:       "7a7f84270a50887307c8168ed5bd98817e85ec27f18a95538452f8a8636491bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f815cd4cf56e8dc7cc09fa2fc959bd8d430be8c6a9bcd12cdc558980c6e76dba"
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
