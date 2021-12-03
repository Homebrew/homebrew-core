class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.166.1.tar.gz"
  sha256 "45ed148e2862023b79259c11a75b5d7339115ae29c97b6f4e5a3411f1d2ecfaf"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f2f17d3fb2445d5fec63b4ab0f544a840f567353af71827238608007576d67c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d68a03f01ca310a61ddef1fb3880a4d4cc4135cd3feed5f846add78993549917"
    sha256 cellar: :any_skip_relocation, monterey:       "d55df73fd0f8d3f957385975ef87c95c8eb155fc1550da9710a5ab0a0b1a4619"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8a488816a92697691c6875ce029bd797925413d4107b9b7d5bc38cba7cc9e16"
    sha256 cellar: :any_skip_relocation, catalina:       "1078843cbf942e20ab62df6bf64e460a34acb7413938c0d71eeb10c1dcb096ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b2cee636c4ef2e91cf5ea7dfbc4a592253aa620ccb7691b57d85c6a45f0c977"
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
