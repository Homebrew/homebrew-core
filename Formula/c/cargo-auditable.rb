class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https://github.com/rust-secure-code/cargo-auditable"
  url "https://github.com/rust-secure-code/cargo-auditable/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "d2b81a7da3cb6c03d8cd977c36dc9adf7f2a3a587ce7c35c8e97ced5a9c83334"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-secure-code/cargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f262f7d8bc92cf558929c88d60ef8571114c887182767a885589430bf0b76445"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "291a8a2bac8d70e740eea6a9517623a5dee17b02d3c9e1b452336ae9012f4bf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c4aaabef81a8470c68222551b72ca770d053799fefe5524e5abb4a81118f209"
    sha256 cellar: :any_skip_relocation, sonoma:        "84883b498f62084cea58a9382a5f4df0c3dbd4a3eb9ddedf3776be99dd9c27af"
    sha256 cellar: :any_skip_relocation, ventura:       "c0a7ae1a9443759198eb472367e852efd2235260f7d38933fef83b7e49a4964d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0a2ac3a3aa00a414ace606bfe0b27d20f35a7338d9c4291facdce5f5a65479a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea3277f0750801cd8d4f547656b5e84e468759235889b6aa213cecfa27b3fc44"
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

      system "cargo", "auditable", "build", "--release"
      assert_path_exists crate/"target/release/demo-crate"
      output = shell_output("./target/release/demo-crate")
      assert_match "Hello BrewTestBot!", output
    end
  end
end
