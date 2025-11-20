class CargoAllFeatures < Formula
  desc "Cargo subcommands to build and test all feature flag combinations"
  homepage "https://github.com/frewsxcv/cargo-all-features"
  url "https://github.com/frewsxcv/cargo-all-features/archive/refs/tags/1.11.0.tar.gz"
  sha256 "feddbd6a0d517e1813f51080a828a17841a2606c97c61be69b693c2fd1f5c30f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/frewsxcv/cargo-all-features.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d3cdd51661611f40f1d134e81810db8433a5a95fbbe13b567207d824279bb3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0860aeb28cb90d8fe0b7fa368874ec7b4c382e0c9efb876c96d9f98c7b952bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9222951548258bb15a5c8627dbc09cd1e68b6e67a126c83d2e67a56ac1f2c912"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ef859885303a5874fdda2dfc755c2b9fc75c2f096fb849f9d1b7abc1fbbd398"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ff2741da51727362a55ebca9ce66f6e3149488823e95361a4fef9c6abf54671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc7d5343f81c3efc965ef1910cfb8db224fea2d6b6c275dc9cbb71887f146ca"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~RUST
        fn main() {
          println!("Hello BrewTestBot!");
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      TOML

      output = shell_output("cargo build-all-features")
      assert_match "Running build crate=demo-crate features=[]", output

      output = shell_output("#{bin}/cargo-build-all-features --version")
      assert_match "cargo-all-features #{version}", output
    end
  end
end
