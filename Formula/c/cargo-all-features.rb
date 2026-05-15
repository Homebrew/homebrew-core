class CargoAllFeatures < Formula
  desc "Cargo subcommands to build and test all feature flag combinations"
  homepage "https://github.com/frewsxcv/cargo-all-features"
  url "https://github.com/frewsxcv/cargo-all-features/archive/refs/tags/1.12.0.tar.gz"
  sha256 "912a62e134ddddf3b98c254e80a547567d32e60a63e1e9bc5d9a1bd93c579894"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/frewsxcv/cargo-all-features.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98ba4d31578fc103d09b7c255b621cd43665f9f335a2b7a35fef21649d0d6aa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1175f2a940275fe77a9ca02144ffc55778c9d4ffa2fc92694df644bb0c96e65b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7496e2caf20b0ca8e2439f3889b92b052ba156e23fc001b1995e054f6e42c742"
    sha256 cellar: :any_skip_relocation, sonoma:        "339f870ac8cdc50e3b25b0f773c986fb77ff3dff8762ca9a3be747b18f9e0fc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7715ac53d58b7b8730ac7af01596741ecbf145f24ce6ab4be8acbb74582365e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6ee7cf6deaeb736df34005dfca4fd3b85e725423e497356f54158f0bcba557c"
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
