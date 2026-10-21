class CargoRunBin < Formula
  desc "Build, cache, and run binaries from Cargo.toml to avoid global installs"
  homepage "https://dustinblackman.com/posts/why-does-everyone-install-crates-globally/"
  url "https://static.crates.io/crates/cargo-run-bin/cargo-run-bin-1.7.5.crate"
  sha256 "1ba4ea665f68a2042470ec6e27a36755783ebd3367b90bec2fb100f9d5012fd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cadd68946820502d065224e4b9feab8057faa9b64cf5e7ae31d7ff8a69dbf347"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "612fe1b5e4612cc02cd894935bc2972b97bca307eeea86dfe2338f5fe18002de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ac42ea13ede216ae5569e303e3928602072bed15dbd27a9b9a3df7a075d3c8c"
    sha256 cellar: :any,                 arm64_linux:       "cfdbcbb1a58e6953d861edae620bde85414911cf87b8691801ce256d69e98d6a"
    sha256 cellar: :any,                 x86_64_linux:      "50d405ef6432dbf05e43108cea83aba288aef176bb55daa19bb223e1cb161e19"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "cargo-run-bin #{version}", shell_output("#{bin}/cargo-bin -V").strip

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "homebrew_test"
      version = "0.1.0"
      edition = "2021"

      [[bin]]
      name = "homebrew_test"
      path = "src/main.rs"

      [package.metadata.bin]
      cargo-nextest = { version = "0.9.57", locked = true }
    TOML

    (testpath/"src/main.rs").write <<~RUST
      fn main() {
          println!("Hello, world!");
      }
    RUST

    system "cargo", "build"
    system bin/"cargo-bin", "--install"
    system bin/"cargo-bin", "--sync-aliases"

    assert_match <<~TOML, File.read(testpath/".cargo/config.toml")
      [alias]
      nextest = ["bin", "cargo-nextest"]
    TOML

    assert_match "next-generation test runner", shell_output("cargo nextest --help")
  end
end
