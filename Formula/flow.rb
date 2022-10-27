class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.191.0.tar.gz"
  sha256 "6dc6f294b4df1a53dfc04f6cb2bce77c6dfc7b80dd3e068cd6c0fad863d4fbf6"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0b291adba40287ef8bbfeace076fd35b824280818c70470f4a6733ff8d0b21d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c481c7c7e8d86a5c363adc585f3709668ea83f65fb23139e9d848b7d23641bfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a553fff9ec44f637ba1e7892b4ebc1cf46ebcd4789a8e121c6830e0a836bb22"
    sha256 cellar: :any_skip_relocation, monterey:       "950bfc888a84ded10c33c94c5538e770d76805b09cb891f0243274ccef74d188"
    sha256 cellar: :any_skip_relocation, big_sur:        "46d5c980d716aeaabaf181aefb1b760cabeeb15a4b18d03c518aca19918a2569"
    sha256 cellar: :any_skip_relocation, catalina:       "9e6194c3c0b1f1c6e8af680b0e25cbc289aef8a91672f33ab9a1119c166014ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "826f1c3e9aba3e4309811d6bbdc501c409e884061002cff6157805941f49ff7a"
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
