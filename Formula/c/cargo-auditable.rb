class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https://github.com/rust-secure-code/cargo-auditable"
  url "https://github.com/rust-secure-code/cargo-auditable/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "04cb1c742bdd2ed0ddbb0e05a89dba24a00391c9145ef357c23ff653eba8c166"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-secure-code/cargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a81e23900ba84d7551b05790269fd491730a336914640fe6b9ef4d00799e220"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9fdbc2bf0aaa50fd3fa46547e5ed25bf0b147c76f1129d99634013e32cc2e6db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "341a7f5b45396a846efc7367aa921a27fc46af8541925295f5a0e247a2b07517"
    sha256 cellar: :any,                 arm64_linux:       "f374033286f0e929aa1dbf1943505a185c460e638dc3bcb6363ba29751b43753"
    sha256 cellar: :any,                 x86_64_linux:      "d91366bef7608b030c0167630519296e26558292aafe9c322a94378c788dd0e9"
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
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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
