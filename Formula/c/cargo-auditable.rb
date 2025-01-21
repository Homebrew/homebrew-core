class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https://github.com/rust-secure-code/cargo-auditable"
  url "https://github.com/rust-secure-code/cargo-auditable/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "adecc1ccf8e86f4e3734767ee6a1c90e04c6639a4f73a59ac2db68a07220c807"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-secure-code/cargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4a53d9eacb0c9aa937a9c3d5e5fb7ba62a47d4308097d2c7991100101c5cb0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6b0fadb29dcf17629b37a38e8890ae36280a1b065b6247e86c5adda465296e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cb6e8c4c0f4e56e49d1fdff4d84a9b5a756e7baf5715576fc04ede78499b4e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f78f652b37f307d3df5d902a8627f390502fcb6b658d25def21323cff7bc37e0"
    sha256 cellar: :any_skip_relocation, ventura:       "85b0450e262c72b68fced5f3bae43f1ae16dcd6b9008460773dbb42b0f34ce24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36add51b1b9f2187c2959c6a7ec969e1e101e565833b3407f4447d7020b2215e"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-auditable")
    man1.install "cargo-auditable/cargo-auditable.1"
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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

      system "cargo", "auditable", "build", "--release"
      assert_predicate crate/"target/release/demo-crate", :exist?
      output = shell_output("./target/release/demo-crate")
      assert_match "Hello BrewTestBot!", output
    end
  end
end
