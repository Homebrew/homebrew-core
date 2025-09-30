class CargoPublicApi < Formula
  desc "List and diff the public API of Rust library crates"
  homepage "https://github.com/cargo-public-api/cargo-public-api"
  url "https://github.com/cargo-public-api/cargo-public-api/archive/refs/tags/v0.50.1.tar.gz"
  sha256 "779ba388aece1227bd074c39bf90eadff7e9edc1238d6d5691fd69b4bf8cd47c"
  license "MIT"
  head "https://github.com/cargo-public-api/cargo-public-api.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9197fe1047e7f21a85f96fa143486d6a4bbb4a3e126d3bfb19ad0581fc149c7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c7444446cd605cd2a5b9410aa9b007aeefad52eebf8a91b5786606936984792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f1a31b8ecd2e6a8aa2ca2d861b8a471a2ba43dbeaba4b6b7ef097b9633888f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "273416297384313a0efbe83b4fe6f6c615881e338950600d0a9be0880fcfc8a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d046b185a172a1f9c85e4c9c506040765ac98a30ae8287f586bf6b0566cab84"
    sha256 cellar: :any_skip_relocation, ventura:       "e90934f1b896cf82b12ca0b4757d0b6b763432e93b3ce499aa2a22b8fab635b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c1719b63932b075d2536b9645446723c525fcc171e5de3d877b7351080d7ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "280e37e71e73d6afd1642f46824f81f5006bc2ba6f00b1fb47c4fca9d9f175fa"
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
