class CargoPublicApi < Formula
  desc "List and diff the public API of Rust library crates"
  homepage "https://github.com/cargo-public-api/cargo-public-api"
  url "https://github.com/cargo-public-api/cargo-public-api/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "0e0bd4bee8f3faae66bc2888d0e212f18239568210b6c92dc4c76d20ac1a68ac"
  license "MIT"
  head "https://github.com/cargo-public-api/cargo-public-api.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db071533a416d48c8c480911fe57919be1099fea22d47e5ba28a6f57d70fc35e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe411e1973d77e0095539997133446cbc5d538ae545045504472ad22336131e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64fac561c8ed9bb6c5599c849368cbc30aa2b119fa93b29d9ea0e0b6e0fa184d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a56c19d9f03c1406d2cd07811f1d39a4d3d708f6d077f46a257cb6d24197aad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcd2622f306044e4ab7ee59800e38ec6db605f40155d15a9c2a91669dc49bdfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77750f9b71e72aadea7e3e61bd3912d697089c9c2de1f733a312519df84979ae"
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
