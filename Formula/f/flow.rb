class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.339.0.tar.gz"
  sha256 "b714f175f0d1ff430396745de910f028ba5cbb6d2fac9ad61ef189a5472afb32"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ca860fce9a6fba5f10102d8d8b748cc2c48e142f785b1d3bcdcd73852af64ed8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57ff044cea4f893ef7c685b8feb219cb2c9c90708b693772d344fb9c53ec2c24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a9edff97b875f3071820b484fd7933c2673a9f8cacc81c4964cf45168ca31ab6"
    sha256 cellar: :any,                 arm64_linux:       "fbca72f2cf84fb66e0d8fc7577b4b2c277e9e28775d6c638e52bc6e454635009"
    sha256 cellar: :any,                 x86_64_linux:      "9a6d8877691a82e6a6a3b5d1e5893199e202a6cf72b46576d624eda373ac52af"
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
