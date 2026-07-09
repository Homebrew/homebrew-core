class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https://github.com/rust-secure-code/cargo-auditable"
  url "https://github.com/rust-secure-code/cargo-auditable/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "8e6566cf51444f6f6d10230e62487979fa79247fe027d0a8acafaa88e6af0fd7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-secure-code/cargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42bdecc89ab0895ee11bf997ba9a52bed7be341f8baddc9e7961710eeae7c9dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a72c019bb5ac44deb1e13aff89dbecb5e0922ba90498a540ba7520e967945df5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a5cbd5232cf0738c77480f22178f64dcc7e682312d4d98c7ca1387cd86c616e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7c94a54624d9888e777e39ac53e94527b024fd5432055000c0f71c5c07aa651"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70a04a8da2bb327cca8a8103e134c9bf533175b3a576d950511c3535f3f4f52f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f37f3010df2271d49f04a84587789de3530bf13e29037b2432cf5d5142f188d4"
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
