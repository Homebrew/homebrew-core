class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.202.1.tar.gz"
  sha256 "64e17678896a2ac04cf899ee23af4b042748fefc382accb91ec98a8b2c06e92d"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11f96694d3acab5bad9d782d48f00c1e500ef8f01a7c8cae235685c6c6f3b654"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8146d691b0668d52ef847d428f9c7a6943513e2ff4648d640dd74a5a17d88050"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d72bdaf53d68c5a54abc09ea637099f18328c6241b70328bc8f1df6145d55acd"
    sha256 cellar: :any_skip_relocation, ventura:        "4a5bf50025abe6931cf03d8b3f419fa7fa7c1e32473c824cb07a4ed2802843b2"
    sha256 cellar: :any_skip_relocation, monterey:       "003a2f0eb6fa66826aeaaf9b988d51b1efb42eb8353b825e2c989eeed0db40af"
    sha256 cellar: :any_skip_relocation, big_sur:        "0414a73d3c5e0fd1f13d33f44d3d37f973799d1476d9bca543a0e6725bf892e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3239c0a745e76524d5dbd9c54950f71aece3f469f14bbfbdc07b06149f9f4d1c"
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
