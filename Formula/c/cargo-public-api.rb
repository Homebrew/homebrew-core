class CargoPublicApi < Formula
  desc "List and diff the public API of Rust library crates"
  homepage "https://github.com/cargo-public-api/cargo-public-api"
  url "https://github.com/cargo-public-api/cargo-public-api/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "cc6328f092fbf3896eee8f28c32e36420d5cca400d5fc18f43fc0932e05a7ba3"
  license "MIT"
  head "https://github.com/cargo-public-api/cargo-public-api.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6fb7758a1e0d0ddf055f42a9244794c2c6b8797aeebda9b659b2b28e899f4f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c2ae65e24c70e29a01a9e418c46dd44041e323b327deadb211d68ac0a67f308"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b2d129303e9388ad71c6442fcd1c53f8625d7e246da4c01e2911741f3f7f186"
    sha256 cellar: :any_skip_relocation, sonoma:        "39c0476c66f5338d1e539225ae4d0b5ef0e9cc5a232edccca74e0098343a2b0e"
    sha256 cellar: :any_skip_relocation, ventura:       "747bed135e9ec87919deab7f35861639fca60be934c4df083b85e8a5afb17014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79610dff0462bc1ebedacf09a77eb0abd4ab47b71deb50a5c87d09685b715a41"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"
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
