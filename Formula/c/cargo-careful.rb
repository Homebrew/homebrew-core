class CargoCareful < Formula
  desc "Execute Rust code carefully, with extra checking along the way"
  homepage "https://github.com/RalfJung/cargo-careful"
  url "https://github.com/RalfJung/cargo-careful/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "fa822e2a0eec050af6c3ee59db02b896a66339594fa0e6f67dff532bb5bdc2fb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RalfJung/cargo-careful.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9233648b8da8a05412c84988f8185b630b002b7aeaa651d23fac2766bb5ca99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23da051d8481eb4cbc975893d583d5a132185535f5551af82d683149b39cbde8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c235430e7f6b46d9786ae2211498e53741f710b2cafb30202e0ca0e924af7f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7220ca95fb1ccb4ee0eb90f0837224b6c8eecf72ebe8dbcd3db5aad96098769"
    sha256 cellar: :any_skip_relocation, sonoma:        "70279ff00ffb65a2fbbb70151a3c316ec18e484dc455848467eedfb086d0336a"
    sha256 cellar: :any_skip_relocation, ventura:       "527c1522e7c2a0b65b8c19b966ff2eb0c3915840e14f8fe67cc709bcb32dc092"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0fbedac308d44d4efae6be65fc20159034df1954954c204111a01f0c1090d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "642e2323e43bd6180710fd6f8aff52668f7a9ff781cf43f412bc5a58d64a1493"
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
