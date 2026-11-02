class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https://github.com/taiki-e/cargo-hack"
  url "https://github.com/taiki-e/cargo-hack/archive/refs/tags/v0.6.46.tar.gz"
  sha256 "8d7b96cf5c9e57c615b514c42df034235b65fdcf2c6e285ec375065294e930be"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8bfb3e486d8648054d8b2f6d1d6973d29469e65ac52c7bb57f811a4e0a405200"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b61aaefdead7fb3ed166b76e07c030aad11d86f2b971cf38295c1a082f05128"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fea2d1266cc9eb68d769dfac2ca86a3e7a89c24de74b5c0d29b7af541654a89c"
    sha256 cellar: :any,                 arm64_linux:       "b24fbe1dfa3271ad3babdb9c6cc94791b05daf39ee8d5a1cac76e886a02c2d25"
    sha256 cellar: :any,                 x86_64_linux:      "fd8c7c1bbc8e1b38f843b976696065325b2924b27a2261b508f6c084dff77413"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  # The test downloads the beta toolchain using rustup.
  allow_network_access! :test

  def fetch
    # The release does not include a `Cargo.lock`.
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "hello_world"
      version = "0.1.0"
      edition = "2021"

      [features]
      homebrew_fail = []
    TOML
    (testpath/"src").mkpath
    (testpath/"src/main.rs").write <<~RUST
      #[cfg(feature = "homebrew_fail")]
      compile_error!("HOMEBREW_CARGO_HACK_FEATURE_ENUMERATION");

      fn main() {}
    RUST

    system "cargo", "hack", "check"
    assert_match "HOMEBREW_CARGO_HACK_FEATURE_ENUMERATION",
                 shell_output("cargo hack check --each-feature 2>&1", 1)
  end
end
