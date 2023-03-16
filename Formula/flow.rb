class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.202.0.tar.gz"
  sha256 "d528d7b5fc4f086a242d8e49a7b791c99b18b24cadc71e10c7321c7fc7583447"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad7b540c5de1d482eeb1b73fb05593830b3bd14397bfbc07d2b241423e2db235"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d42b43b33983ff1c451a1b730de9c9fd745350809bac6f31a1be0d3a81df558a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0304e8f81e31de7e246ee4a1c3e0d0facdbf2e8b7896e41a5a9c7ad00efde950"
    sha256 cellar: :any_skip_relocation, ventura:        "57dc265d1c94754dcc5dbd1133a642a165a80ccc7319e8a2b02ce225d1546985"
    sha256 cellar: :any_skip_relocation, monterey:       "9fdd49cb7466156fedec562f982d68631e131d74c2b5839b89c3570f0178c532"
    sha256 cellar: :any_skip_relocation, big_sur:        "66dbf50351f728afda1c65d2db019afac6ce918a9e9e7bfa955542ed547db6f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0be098d9e8d16520cddd1e0fc5527149309c98d5deacd0f4dd2171022f10d444"
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
