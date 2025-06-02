class CargoPublicApi < Formula
  desc "List and diff the public API of Rust library crates"
  homepage "https://github.com/cargo-public-api/cargo-public-api"
  url "https://github.com/cargo-public-api/cargo-public-api/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "d91316f162e504f6d23cffc674d2de788299a27407d170c2db734b79c2337323"
  license "MIT"
  head "https://github.com/cargo-public-api/cargo-public-api.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d1795aeac86392044b183e9b2117ff67e7e758cfc8b22ff7176276300d70a40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "751eca35a24cac6796d1f248a4f7d6171c89f579d0cad99b0a6de76df06d173c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7dc10ab897b029026d85034fa6377e6cbac2c2154d182da31410d25d60e5ad06"
    sha256 cellar: :any_skip_relocation, sonoma:        "4645db47215bf5d8277044d1d4827d85e5e4620ba98876513ca8903b5308db08"
    sha256 cellar: :any_skip_relocation, ventura:       "a24303eed3db33b31ea76db2f0c6cae6b8fd8ee3eaa93922c0b5b53304100c66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69ff2da3dce7124e0c540092807ca89896ebd68f397231063a7cc2ffa04b2b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fa3be24890d9551871cebc8ce7e7f5aa460acc32c9aa958984dd87897dca31c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-public-api")

    generate_completions_from_executable(bin/"cargo-public-api", "completions")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"
    system "rustup", "toolchain", "install", "nightly"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test_package"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath/"src/lib.rs").write <<~RUST
      pub fn public_function() -> i32 {
        42
      }
    RUST

    output = shell_output("#{bin}/cargo-public-api diff")
    assert_match "Added items to the public API", output

    assert_match version.to_s, shell_output("#{bin}/cargo-public-api --version")
  end
end
