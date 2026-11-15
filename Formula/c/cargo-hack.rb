class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https://github.com/taiki-e/cargo-hack"
  url "https://static.crates.io/crates/cargo-hack/cargo-hack-0.6.46.crate"
  sha256 "610b45cb5e6170800c3cf7cedc020af3b8008dc1596633761f75436aa38cd051"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-hack.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4832ba24b16b7ba02004adf2dca0a8906111b83dd45487cb9423b73cb70d3de"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08c833bcfd850546eaa9ab41ba0808aa8943b1df7ba7f313dcc324c19c656b29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5369b22798c58c87944f6ca3ed3d6523e706f1d2f9b1efbab4ce938230c95b21"
    sha256 cellar: :any,                 arm64_linux:       "0a9a21ff368a1ff64d8c3f9ed354dcbb247f144d545c75381adacb377f108223"
    sha256 cellar: :any,                 x86_64_linux:      "a3493e79bd6f6589179b9554be8a8b0f534d2104311fb020288f1545abff679b"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  # The test downloads the beta toolchain using rustup.
  allow_network_access! :test

  def fetch
    system "cargo", "generate-lockfile" if build.head?
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
