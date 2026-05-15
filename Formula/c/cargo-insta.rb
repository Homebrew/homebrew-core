class CargoInsta < Formula
  desc "Snapshot testing CLI for Rust"
  homepage "https://insta.rs"
  url "https://github.com/mitsuhiko/insta/archive/refs/tags/1.47.2.tar.gz"
  sha256 "487c7348fc8865fd3218c4252f2603238af1b6ae3501fe51577fb5abd4fe5323"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f011c92e70e9f1f7517c67ae3476b57afa3d95571462868eb61e863092299380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "703b943e5a9c46aa55e47b406a31d2b3962f1b2c9ab5ba4dd329e0a724d74165"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83cedafd07e5d36b24f2691913c6fe41985e60202440033fb9e2c07b5979b3e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a6664d076b94b6ae0f21949db218e377c8bf2872b4f5a516d705cf07bcf3118"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69d6002f03be6c565732ad355c2eda8348212e72a7f7f1931d4834a7fadf1486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06d76b025860494437510db2d2e51b37b626bbc3858fffc325c4b55bad468d22"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-insta")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cargo-insta --version")

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
      name = "test-insta"
      version = "0.1.0"
      edition = "2024"
    TOML

    assert_match "done: no snapshots to review", shell_output("#{bin}/cargo-insta review")
  end
end
