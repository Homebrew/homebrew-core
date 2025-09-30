class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.287.0.tar.gz"
  sha256 "b05dfa2b44db5b16e9d9d98b4480fe3b34ff5ff1bdbbb74d731ab9e7696380e4"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06311b6651420baf457f9b6dfb2f79a25128a02c0afec0b4cd4b4f3aa5e6477e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55811c1789271dfbbf028eada273603462d2f3c349c1310dd6b159e83d2ead7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c574be995f02d50b2dbac65b478f2f8496f9a6e6446893ff95cdc4d9b3423250"
    sha256 cellar: :any_skip_relocation, sonoma:        "dee1399956aab8c37d424a98f3ff7637fd0715b1a738a5cf9dd8cb6790199f7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6859b3d124b7f3b0fef174d93ae09ae1f68d4e5f8aa548952d9306ea544d74ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5353fd1d4a316ddb60af68f825c0900f8686d88546ec8b3cee9b976efba6e54a"
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
