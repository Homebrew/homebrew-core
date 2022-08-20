class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.185.1.tar.gz"
  sha256 "a897156119e5eed3306a07beade3e20a4b7008ab6cfc9c40c66a42f88be4320a"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5e2945a0821e19d3eb9c60ea79f1810155222659dd4524a26dd3a8e8401a53c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19c0f67a8febd1929580fabb21a8f836b78dae7b429b2c17e23cec4231ddc8d3"
    sha256 cellar: :any_skip_relocation, monterey:       "e484a0ef632f0c4505c1c96cd4efd9491b38daffb127430de3d48a3aedf9ecee"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e489e8bec11c132292b1f802db05790cae1f838b3178d11479a9638ca4315c4"
    sha256 cellar: :any_skip_relocation, catalina:       "774da03c669d4463ab272f930e0c6e7d16badf97e518b66420aa1cfdd0907f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ecebf3870c541efd4e117d81f1cc747427fb277adbbd133d6606dd852affe45"
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
