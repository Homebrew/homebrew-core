class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.275.0.tar.gz"
  sha256 "07ef1c405fb42239daec56c3175ea5e41f71ba2bc478e1dfb63a9c643f504367"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b8270d2c9f4494b891a5ec24432eef84e03b6757069edc054e42cfc37d94c6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43252fe8a940078004f0e4eb39e79a347328e86599efee6cc26d1a954baa2a9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae14bc0a29eceeaf94a646302ef6b5f4791e5c60f9b3b85df5854f1cd49edc4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1d9a626d056c1a9fefa0d825eaecbd52d6474bfe86fd296b07507521d1bcefd"
    sha256 cellar: :any_skip_relocation, ventura:       "9dbcc0a521c9449f00cc50c353c92989160a62deb416b2ca403a185390a85151"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f17c0e11c29d5ea936074492b04ed0ac56dbf9b784b5c26691b80663349b010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1b161985f521a6d762907938e012c2714e7ad3fd24aed22d1b4a58f7facd11"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system bin/"flow", "init", testpath
    (testpath/"test.js").write <<~JS
      /* @flow */
      var x: string = 123;
    JS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
