class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.181.1.tar.gz"
  sha256 "238aa06391ecd7d6e6b14d0fe7e4cc14ceec1a18a12254989a1637a1bfd05a4d"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0255191a68c3c90ec80b83d1a5429f644ab81591fce367df184594d10f0653bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4edddfca1c38cbe7af65c3e9e6009faab7ea30e675de004c06782cd3e0331a6c"
    sha256 cellar: :any_skip_relocation, monterey:       "93955a564dc4f87dc197f995bfb1b7088304ffa151ce389f03bbefc74b2eb3e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f32f81eedbb96fff28daf6bf55cb4ae9806be1b52eb544bc200bc390ca372664"
    sha256 cellar: :any_skip_relocation, catalina:       "2d049265e692f65faf0cd97b5b82eb7b40c2549418e5e24b4ed9afe089054396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f5a7536080846ae8a00520d674300c47cf803f9c38ae6d5f7b1876baec769eb"
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
