class CargoPublicApi < Formula
  desc "List and diff the public API of Rust library crates"
  homepage "https://github.com/cargo-public-api/cargo-public-api"
  url "https://github.com/cargo-public-api/cargo-public-api/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "4f62319b6e63de7f5b8a50797074f66f99ff0fc5813c2777c34c7d91d27e2a3b"
  license "MIT"
  head "https://github.com/cargo-public-api/cargo-public-api.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "219fb19a75d3a741234415bfc15194fd58138a73767ec81938249ebb56f5d3ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34796f378455927673533bb12dd26e4e9d497dbe79f1f56326c8db358bd9cf6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba2b981178ec3490273007001852032644bfe6f24a27f27411ebd5e43bd528c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cd3dd1cb79637f25dac30b8c6a5dbc56947ac93821c952e91708bd434b9dfbe"
    sha256 cellar: :any_skip_relocation, ventura:       "517abe6c4c8f84724f8b3d0cd127084453c8c0d519bb1969afb6f82e21385044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ef03ec4800938da8474168faf030799599a8a66d5c5f3a372f7cd84d6fafff3"
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
