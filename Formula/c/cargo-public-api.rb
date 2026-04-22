class CargoPublicApi < Formula
  desc "List and diff the public API of Rust library crates"
  homepage "https://github.com/cargo-public-api/cargo-public-api"
  url "https://github.com/cargo-public-api/cargo-public-api/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "7fab168d6d60de8ff04b97fb25f2fc5f677d65344540b567ab6967c3418ff60a"
  license "MIT"
  head "https://github.com/cargo-public-api/cargo-public-api.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52d7d7529e138b1c18c273f6ef717d7584a0b71793531b410690af248fa382fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b46863155bb564a1738e7f408cde099a13722d073ec55ae748d3e316b0b0bcbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e0534d89d251906db9224e140ecd50c9eb8152b224bd4799e3a9e9a9783dd60"
    sha256 cellar: :any_skip_relocation, sonoma:        "909c2aa1edff92218561f4b0fe70aa9dcc101ab9a6c0c96af6f04a80041b4f0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "917174fc92c6b0d7bb585660e3178fcb59b8f1e39fc1f060e353879a5ed91334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed09e185db1f6e309f8818185003679d77670b5a8cbe0014914c463f9d863de8"
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
