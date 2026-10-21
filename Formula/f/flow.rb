class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.336.0.tar.gz"
  sha256 "5fce1112dad0b9d7489211d18efc0185fd11b040bea5a17cc61f79947d927371"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bdd4a60d53338058c240a463f9d4c20023f5f7de8f0c6499b3f2ab03d106159f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ac9f5298d14725f5b09cbfdb2a3922226ef890134b43886968b5bb76f8ccff7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ac2e3c3ae69ecdde5e7591abe18449137056b32dd3b2cfa8312aef08232f642"
    sha256 cellar: :any,                 arm64_linux:       "c65b2647aefb97b0b89bf8b23f916b144311ef6c1d6fbd29f546d6baca2533e9"
    sha256 cellar: :any,                 x86_64_linux:      "81fd181f7c0bcfa1dc8105c5c445bd3aad03b30feb87b2bf8927b9e95c7e6a6f"
  end

  depends_on "rust" => :build

  conflicts_with "flow-cli", "flow-control", because: "both install `flow` binaries"

  def install
    ENV["RUSTC_BOOTSTRAP"] = "1"
    system "cargo", "install", *std_cargo_args(path: "rust_port/crates/flow_cli")

    # Resulting binary name is `flow_cli` but in the release artifacts it is renamed to `flow`
    # https://github.com/facebook/flow/blob/main/.github/workflows/build_and_test.yml
    mv bin/"flow_cli", bin/"flow"

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
