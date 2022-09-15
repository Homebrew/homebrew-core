class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.187.0.tar.gz"
  sha256 "15fec4e88beb21ebc63091f71e97f33a0453485c5fa14d811fbdcafd2444ab0b"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16668ed9d942d1124609bfd7029bb03afd4c28069c16b0c049bf90ee528816d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eccab5ddfdc908a7419d24ce94098c55210d018ffc47d6a3eaba2ee895b31c83"
    sha256 cellar: :any_skip_relocation, monterey:       "073bd124936e7ef5f4981c1d1b92ab4961ed37bbdf205c039a4c3f223e1202b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "29259688058c1eea61c0c4b94aea400f7499f975fd6e03bd785ffbb513d49a3f"
    sha256 cellar: :any_skip_relocation, catalina:       "fc79d7ba709b08d65015d9f698d45af384758d0ed29fc25287b66f28af8fdcb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c79a565c816a521474299f4e378322dabaaa4887e27961b3ed510fab3f64221"
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
