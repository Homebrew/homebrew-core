class CargoCyclonedx < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Rust (Cargo) projects"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-rust-cargo/archive/refs/tags/cargo-cyclonedx-0.5.10.tar.gz"
  sha256 "e32a1a7a6f3766c9bfe8201025f224f6270b3a3158062f9924dd262a669076c6"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-rust-cargo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cargo-cyclonedx[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    manifest_sha256 "5a60a13eb9bfb0ae1f07b081e94b42dbc29b1bfc4c3401abb35e29f45eeb1ec0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6b97a60ca7a1c1cb9efff230726c88e0cc4d11bf29e397cf47a0da256f622c3c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "801a7070bed32e6004d20c0abd06102d442639f6389951397ea352e6201b2c20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c6d1bac217ad86bb5d105c5bee6c4ccfab293bcffe8aef7aa7cee10144631a2"
    sha256 cellar: :any,                 arm64_linux:       "3a9d355033fed6db93f4168d9bdfab51f9bbcbdd8db722d28407b712a8144fc1"
    sha256 cellar: :any,                 x86_64_linux:      "790444e6a95f59efe08c0ba19a3983e695deb8b39c543860cf168bc90c1a96fd"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-cyclonedx")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test-project"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath/"src/main.rs").write <<~RUST
      fn main() {
        println!("Hello BrewTestBot!");
      }
    RUST

    system "cargo", "cyclonedx", "--format", "json", "--override-filename", "brewtest-bom"
    assert_equal "CycloneDX", JSON.parse((testpath/"brewtest-bom.json").read)["bomFormat"]

    assert_match version.to_s, shell_output("cargo cyclonedx --version")
  end
end
