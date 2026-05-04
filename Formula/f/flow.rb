class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.312.1.tar.gz"
  sha256 "a5e9ada75f319b1044e28009db2226ce35678706448d6add6d8f50de60da6c7f"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91392835645418cd45c968d95123715d4176140c5a26fa69c80b90e402a1c8af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7770af9e01845620163368d623df392f81d245d6efe150262eded311f6b646d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4c859ca2772ddc871feeacf692a5edb7c1027b767176bd25fe40bff83a7f3b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "517e8c347d37a10c979e3bbc2dd337afb92a77696095cbfcb80e00ec09918d1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39c8f505c182cd07c798ea1237aba6eb266bcb0afe1db932dc467c1d14df0fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "827533ab315f694ee06a5f550f83c4dffb6ed8f7c0b65a35a177d9bb98a2cf68"
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
