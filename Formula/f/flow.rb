class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.332.0.tar.gz"
  sha256 "149cd1d2216a2d76081e0b6c6d0a83b7f1489a38d12ea91f24c8bec8639bd5be"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c491b17ebb9a3dec53ca8091728e6ca569b76bb4ab825d2b654fe4846e6a0a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "137e025ea47ff1b563fb899d628b4415bfd2dfe1540d56cc5d2887cae1927ccc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1fbc8e0b21e241a53a90cba5d6b16165819eebc7b6f4c1d793d717e05759c18e"
    sha256 cellar: :any,                 arm64_linux:       "80f79084e7b169b3eeb753c5bb4408508751659eb50b7e761a30819d1fa32d82"
    sha256 cellar: :any,                 x86_64_linux:      "5b161f0fe6e0c10371b89761b95244d258febd7011e62c67b2b7cfc85bdbe777"
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
