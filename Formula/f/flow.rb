class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.339.0.tar.gz"
  sha256 "b714f175f0d1ff430396745de910f028ba5cbb6d2fac9ad61ef189a5472afb32"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "792713d187e82c4b58fbe9cf952b7c053a4d5b2967b3c8436896032b60732980"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8803e62eafc77524f01dccca17175ea8694e7fd858693a42a14e5e5cf3881293"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8475a29cf966bc5292e41f8932d4c81be80d380126106fead580accfd6ae1041"
    sha256 cellar: :any,                 arm64_linux:       "ecf73a65fec7b264edd1da92ef7c328f4c791cb2a8c1d77bbd1cc95dcc938e2e"
    sha256 cellar: :any,                 x86_64_linux:      "b4f57dc3278040ce366e5af762471e42c8b0267bc5104aa16a11822c3eb2b608"
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
