class CargoCareful < Formula
  desc "Execute Rust code carefully, with extra checking along the way"
  homepage "https://github.com/RalfJung/cargo-careful"
  url "https://github.com/RalfJung/cargo-careful/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "7010dfb5b501a9287cecf0b143a262625732e0af3fea6385d491ed352b133b9c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RalfJung/cargo-careful.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dceb1280616b1beed9f40c200ade53af14ab9da69a0bb97bff131ad061798da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ce5fb0d737094c5b6e2c373dc011af52f56cd922b5ce0b885345e9e1b3164b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faed12f99aad9c45d6f2d8dc72e796855129edfde0bb71a669f5eac04f11991c"
    sha256 cellar: :any_skip_relocation, sonoma:        "988d5fea11a9cac95b15d2be04704940f5485710c305c0095b653e0030ee854f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ea8b838592392f6adf0d79986abb86193cca86ed7d941967c90fc8f3fdf392c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "682bcb542c28e2f6d6a134c1da144a6f4ca36c046337cfac0da7b467ccc9ade0"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    # Switch the default toolchain to nightly
    system "rustup", "default", "nightly"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "toolchain", "install", "nightly"

    (testpath/"src/main.rs").write <<~RUST
      fn main() {
        println!("Hello, world!");
      }
    RUST

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test-careful"
      version = "0.1.0"
      edition = "2021"
    TOML

    system "cargo", "careful", "setup"
    output = shell_output("cargo careful run")
    assert_match "Hello, world!", output
  end
end
