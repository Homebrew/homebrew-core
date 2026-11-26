class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/meta/flow/archive/refs/tags/v0.343.0.tar.gz"
  sha256 "fcc19bd507fa397fb30582fb068a2a0b2eae0f5b641e3ef47d330b4e30318230"
  license "MIT"
  head "https://github.com/meta/flow.git", branch: "main"

  bottle do
    manifest_sha256 "85a9aec2197aa8a0011e8a4f186dec5722919d7eedcd82cb70de386ce4097d5f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cce29113494ba5799374e69514fdc9e9698885360df66375e93503ecc54e8038"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f2d13b9543f75799fbfffaa69d7f8124dac78d13a02b0271b98a5c44ce24e29d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57226639ce8508392f91d0bcdfeb85fd60ffdd9549912f0ba281d98a79f47dea"
    sha256 cellar: :any,                 arm64_linux:       "15b8738759af663c4361097d28cbbe7e785fab50565c367171be783ed390ec12"
    sha256 cellar: :any,                 x86_64_linux:      "63a0427aef67826c06774cc0eba11d0cbfc1979e63f8fc3a300cca2e2e66fb1c"
  end

  depends_on "rust" => :build

  conflicts_with "flow-cli", "flow-control", because: "both install `flow` binaries"

  def install
    ENV["RUSTC_BOOTSTRAP"] = "1"
    system "cargo", "install", *std_cargo_args(path: "rust_port/crates/flow_cli")

    # Resulting binary name is `flow_cli` but in the release artifacts it is renamed to `flow`
    # https://github.com/meta/flow/blob/main/.github/workflows/build_and_test.yml
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
