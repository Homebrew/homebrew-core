class CargoPublicApi < Formula
  desc "List and diff the public API of Rust library crates"
  homepage "https://github.com/cargo-public-api/cargo-public-api"
  url "https://github.com/cargo-public-api/cargo-public-api/archive/refs/tags/v0.50.2.tar.gz"
  sha256 "e9ae0d0a6ac5582ad99be45ef0d3f77a852e1e38e970fb2c8812337a6f997a79"
  license "MIT"
  head "https://github.com/cargo-public-api/cargo-public-api.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65f62e4639327b4515376fd6d35e7362bf47d241da47679dd8ac38f1cc599556"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "644f56927fdf51f3bdb11a5f65bcb0ee5d9f838172f4069e6a7252cef474ad39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4814623fec5a8d62f7858c9174ef2bf908f128fa954222522fa3bacf7099ab4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d719981123a7ed3e93354195df8dfda7072730a9a0e3493bb1ea67e4c096dc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcb1668c2650fd1494130fc7871bb0283799f6d868dbf578f4311419de08c8d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77abd1809b267e67651a81a37a37cd084798985da3f95ed90a97ad3a667c958f"
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
