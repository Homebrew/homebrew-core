class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.328.0.tar.gz"
  sha256 "42bbf3c0450d8fc2d27d9b2a3cf16738fd0e5c35779f9e572b99f4f08049d8cc"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caf568cbcecd2345f8b7256cd21c228713560028dd1e15c3f35dc93254b47261"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2ba3608470a5a327db8314a2acb5b6ec3427c6342b44da84c3559952de8309a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25b918c1c334f122ad959e01d64d887b1f536b846745feb074f29e69f6a6fba2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8ac59bc23a8f6563894592a1d2cdd067bfd9e9125d87d24041366481ef65162"
    sha256 cellar: :any,                 arm64_linux:   "1ca5ae4ebab88eee7699d6df318af8dad92f64853d966a47e8ca4fef3e5b982f"
    sha256 cellar: :any,                 x86_64_linux:  "0f579098b701c854f397245e85818702d47c99522b73cf910212ee0a7cc712b3"
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
