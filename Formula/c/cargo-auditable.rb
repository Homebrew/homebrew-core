class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https://github.com/rust-secure-code/cargo-auditable"
  url "https://github.com/rust-secure-code/cargo-auditable/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "cab2a4b65cfde0734c98416740d24d4e3f03441ea8a0b385f0431e35244a05aa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-secure-code/cargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a66d872430a41061ab4f64aaa9693ba2b5f3df3aa799cdefbc3a69f53ced0ff5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0afffcf64e05a21a723357c0c452a0d1d9c9848d6af77cc48862211b8141cea3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27b846616113f903d9671f2ae25081150296c45c2efe502f323e268144e1826e"
    sha256 cellar: :any,                 arm64_linux:       "978f1ad0b26789856f8cceaf246db8f04a9fed06e1e8671074433b54937fee62"
    sha256 cellar: :any,                 x86_64_linux:      "2da8addf73037eac36eb07ab06abe75c971c61fe295aaf31e6ff1fde1dd77638"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
