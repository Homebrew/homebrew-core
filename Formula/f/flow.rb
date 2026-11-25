class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  license "MIT"
  head "https://github.com/meta/flow.git", branch: "main"

  stable do
    url "https://github.com/meta/flow/archive/refs/tags/v0.342.0.tar.gz"
    sha256 "9964e7ba88755be8a23ba4bd910b57a115cf46b39c3a25c757c20e04f143c996"

    # Replace `box` patterns, which Rust 1.100 removed, with `deref!` patterns
    patch do
      url "https://github.com/meta/flow/commit/9976dbf5c6220ea90555d25ac97a1e7496ab203c.patch?full_index=1"
      sha256 "2ede7443733e6e5a126b4f7508cd74eb9b0acd55c3ca130c7b03fc42dbcf8f9a"
      type :unofficial
      resolves "https://github.com/meta/flow/pull/9536"
    end
  end

  bottle do
    manifest_sha256 "6e7a6a90c2359d1409bcee2727a35dcd5cdad8b34c69e14df5bdc3e91c2d92c8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4c1493ff48e332c54f3855a35ab33cd757165a1b5ed78967257fe79cfe1afe5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "665ab1139153e25cb737eb91766f48eed753332b091c0826816c0e8a4d84f7a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ce6a9094f57ef8cf14e87f8d9b72c57b519b2a588a4cc51eb65f97fde721e173"
    sha256 cellar: :any,                 arm64_linux:       "f7555364cb11489bfb06140583e7fe4335c6b3e8719835b43f57ede7c2f242e5"
    sha256 cellar: :any,                 x86_64_linux:      "e62105b5dbcef89d17791364b93ea24d9326b1037892e855c49d6625e6b87ff4"
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
