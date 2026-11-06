class CargoCyclonedx < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Rust (Cargo) projects"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-rust-cargo/archive/refs/tags/cargo-cyclonedx-0.5.10.tar.gz"
  sha256 "9a70987a8bda97615ba80127a76e73bb2c1a3cb285b76f1771e2f5c0b0cc2f6c"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-rust-cargo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cargo-cyclonedx[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "148381b33c196ec4791a18d2082dd1498135d7d6c25647244525b0965cc26859"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f61cb518ea956e560ac3fb3abc5a257d103b460c847ea49253fda1ea62d26f74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "32a9a2f59518d30571222bca661f98c1a41a7a11263b1bd9973ee19aefafeba4"
    sha256 cellar: :any,                 arm64_linux:       "5c93eeb8045428d1a81252e0a420d9077558c4da552d9f6da247726834754ddd"
    sha256 cellar: :any,                 x86_64_linux:      "ce21318a6e2fa478651edab8da829b39e0de771f63810e687fd52e176374d3e4"
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
