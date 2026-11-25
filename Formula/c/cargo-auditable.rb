class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https://github.com/rust-secure-code/cargo-auditable"
  url "https://github.com/rust-secure-code/cargo-auditable/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "42dc4181cccccac38b38d877febece32e324c3f72b2664c628113c1686926adc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-secure-code/cargo-auditable.git", branch: "master"

  bottle do
    manifest_sha256 "b661cbf3368eb9ca1e0d47b9b49cdef47ed8575a8d04a43fa091870278ecea80"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "325f720916da4a4f344149ba23c13decaa8dde70511f43b32f8173e390dba131"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e87873e6f081d6e31946a0590feb4d9b36b683b18247a2c8ed0c81b7b8280d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8411069c9dbf7a51929217467238d49493eef3e2aa7a8d5bf3922d62506eec0"
    sha256 cellar: :any,                 arm64_linux:       "5f74eeeb8bc9c23c5b670f45125b2b2062c51e5870e0b1113de23d92f2af4d2b"
    sha256 cellar: :any,                 x86_64_linux:      "2f61483a342ee9343cee74f0ac1863b3f9396d11d428fd41efabc07b3c4fdad1"
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
