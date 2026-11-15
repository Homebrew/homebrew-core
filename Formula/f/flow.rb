class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.340.0.tar.gz"
  sha256 "278ea54ca9f93a1e6636baedafc2b96b32007b13fdeb50763b787988fe59d7a6"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b1b5a66524cb7561826ec8f02835662fe1e77703c452362bd2cc8a4532597b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c18b10b8832ee75f725a09574562754b79ebf4ced6f262b784509a94e06a817"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "51f75107b8458939f3553fcd495c37e4045f7d6a4900e4eb72fec41c520ff802"
    sha256 cellar: :any,                 arm64_linux:       "a9d97771a94430eb88bac250a419d4ba7382d3016e03351edc952e7e0e566a6f"
    sha256 cellar: :any,                 x86_64_linux:      "84ce33d9a3b3b4f911e1584f861ad4dac809a3e688467427d105b2f2351834bd"
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
