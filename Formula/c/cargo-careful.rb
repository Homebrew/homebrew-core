class CargoCareful < Formula
  desc "Execute Rust code carefully, with extra checking along the way"
  homepage "https://github.com/RalfJung/cargo-careful"
  url "https://github.com/RalfJung/cargo-careful/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "494e913f8c99b6d247a9a52aef0bbd9af0e9cf9c3a4144a15769d88c31509579"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RalfJung/cargo-careful.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23cb59889107b3ff442e9fc402d83401ee9555fc8b84957ccde3a57574c664b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e386d3e2c1f4d6cffca6640ba265e593bf5d00df7b809ba2491390a36fbe64f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "932e4dc30279f7184d67a91303284d9e1760697c375f9f5601dff82f7142a537"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eb19b59d5c6753968d55dfac28b68f8374d2f598f060bd95784a569e747f07a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34ece2b3e45487841d2812d66d14d0ae9967730d219fbcba37cc06f03307c51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28f0c18eac5a04e95b551c8755a04b0e70e11f20b291058a8d49390143a49fbd"
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
