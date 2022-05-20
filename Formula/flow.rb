class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.178.1.tar.gz"
  sha256 "63826c5b257a9b8fae94191b8abfdd9f169581bb7fbfa1fdc73d0e2e177bf75c"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cdc27be77c4f7ddb718d4c3bc140e15d39e4e4129ccecfc7ac7637e4d9b5b99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "041f488cb061e099904307c0d03c1097ef558f282bd14790fa9f540020c04714"
    sha256 cellar: :any_skip_relocation, monterey:       "b80f3ed460435a79c9e3953029bcc319789b798fe974ce5965a61f2c8e8f9523"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e0ed2f84910b1d24a71c47affc155aa27a6d6ac370acd19e17b5621533acefc"
    sha256 cellar: :any_skip_relocation, catalina:       "2d448768daeee44a1d37e49e5dfa53fde49c4270ee94ecf0ff1c6323c55340b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a07cd88404bbfbc06290edb8f0f802e7b53429e5c0f3e6ec866f80e2871ed76"
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
