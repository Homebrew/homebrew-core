class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.323.0.tar.gz"
  sha256 "77113be08fa0d1ed70a54cbbae47ad9228153eb1c66c8e7b675c65c76149f906"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a81926d785a3375fd0e495573afe7c8dfbb7c56be6f2f7e76df216509b89802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f007f59e783d2a2518741c44f095f624e8f2f7350cfb725ee4cfdfc82bdc5ed4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56ee6cfc49a9dbfbecca29735b74481f827de9d1709f2e0e731e7e736ec00865"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c93dd4032c3525a25ba21c4fdc8e86cb3f567b67f74361a6164b5e31dd3dde7"
    sha256 cellar: :any,                 arm64_linux:   "b9551fd1828cf74df66a47c3668b279700d768e1d24ac1bab1a7878b2c5244b1"
    sha256 cellar: :any,                 x86_64_linux:  "f9df237e721823552bde78c1fdc76c3856e362d5c4e38472bfc2a8840ce86b01"
  end

  depends_on "rust" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

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
