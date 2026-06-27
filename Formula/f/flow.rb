class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.321.0.tar.gz"
  sha256 "baaa858b07f50e88b476d5cb4aad249ce5535de5e255296a8ec2798cbca852a1"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f4796426b9ac9a3bfb9d91e2dd2bfbd5838724c39ce848b75b17c63d8c3bf90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fde5ec4f55368e11e3191cda2db11cbf29916848f8b0813b83903ac4d3d8d805"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68b3e598e23b98d9976364edb471cf8e23498e79c33ae525dc88b4a4396f9c41"
    sha256 cellar: :any_skip_relocation, sonoma:        "59fd9961b1daa589fff21e4d99589a71b08ea5c89a2e65558fb4fec4c79df5a0"
    sha256 cellar: :any,                 arm64_linux:   "a60abd8de31d493f0883dfd308e02d8985b6d4214209e190dd868d47aeb3189d"
    sha256 cellar: :any,                 x86_64_linux:  "a97345520f203c4e8450df42fe75c0f2f3c3628e45100df9e1b27646a3698c11"
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
