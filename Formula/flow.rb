class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.207.0.tar.gz"
  sha256 "a07d8a0075ab427f06206bf2ac3652fd2d3372d191dd7985caffbd4dc728045f"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d47cabf0da1c8b52d8da72cb7619826a631366c4ba6c6b5ad3f8050c213b971"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b6e3876c5a7a51986ff7c3e94ce5d164b19e016ebcf70ac11ddad8e36498f5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40e57686b8a2c95b7a590e06974139a2e688deb0e5b1b6a05c4604fb0079ffd8"
    sha256 cellar: :any_skip_relocation, ventura:        "99b8078d8a8ecd02d3591fd5d268d8b691b60f7aa1ed5c048d34bd80bc77d0e3"
    sha256 cellar: :any_skip_relocation, monterey:       "7dce1e18bd787109712af3950de8f2ebcf9ca0e3049a975df9695d24d2f178e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "226cc352e9f36178275ed71ca2e4c4be89ef84bf3fce974c23e3ea68836571af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b7a2b74f06db49000bbe07f1748b79c5459a7f79b3742bd02914361d7408b40"
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
