class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https://axodotdev.github.io/cargo-dist/"
  url "https://github.com/axodotdev/cargo-dist/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "3bf0351c118f8f601a985c35f442ab7564eb4979bd9f8a6b6ef88bedf5d37675"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/axodotdev/cargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d2d497bc7b33d10a90db7c137e86d8e1989ce8c49c3fcd4faf409d8f52aad1b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "25d7cb5606cee145bed9b88d7ebd3a2eb90a0a57a23845054533bdfa8030fbc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e80a4e7fde668266311c6ac95d5deb904c374a4082b952161439e3fb1fad737f"
    sha256 cellar: :any,                 arm64_linux:       "4fa15a99d6bf32fe86f5a231be2521e9c92d8644c199e66c4587665980d0b297"
    sha256 cellar: :any,                 x86_64_linux:      "24ac37068faa4b2e5f65a3073e9033fcd0b003f7d628a034efac0e5de3b575a2"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  conflicts_with "nmh", because: "both install `dist` binaries"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-dist")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/dist --version")

    system "cargo", "new", "--bin", "test_project"
    cd "test_project" do
      output = shell_output("#{bin}/dist init 2>&1", 255)
      assert_match "added [profile.dist] to your workspace Cargo.toml", output

      output = shell_output("#{bin}/dist plan 2>&1", 255)
      assert_match "You specified --artifacts, disabling host mode, but specified no targets to build", output
    end
  end
end
