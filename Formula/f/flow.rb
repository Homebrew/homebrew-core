class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.331.0.tar.gz"
  sha256 "39263d9c97665edaa636dead813688676b09f379e08bf3bdf1adff3bddd012ac"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "789b53ad85ae4fef88cc63da11b066a2a721e23c12103677b07aff0e49832f35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd04299f4e6e629bd080b9ad36f0b18a5674e19b21ecf2bb32b13d7a2a510153"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf0cebd4cc8d5a7ff5bfb1a14f8bd0e9d9f102132ba4aa17a0825503596a75b4"
    sha256 cellar: :any,                 arm64_linux:   "7d9fc970925807e80942bfc64adb7cde1508d0e274f3534dbe03470e34824fdd"
    sha256 cellar: :any,                 x86_64_linux:  "4b3ff9cf188fa4b387ea4fc8f117fae1a19a1f3334be843ac79f509997f09b0e"
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
