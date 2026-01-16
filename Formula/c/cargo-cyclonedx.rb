class CargoCyclonedx < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Rust (Cargo) projects"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-rust-cargo/archive/refs/tags/cargo-cyclonedx-0.5.7.tar.gz"
  sha256 "3ac7058fba657f8cfd56c6e1cfb47ad024fa76070a6286ecf26a16f0d88e3ce2"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-rust-cargo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cargo-cyclonedx[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68b837ec5f02542da6437fa257ea5be3b4d673c476a153aae8a7abf10fa2e664"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0929e7f65dd40618265f765e8018119e9b782336f723cdcab119a3e424264edd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "783adfef5d79bf8f14dc6f3f667a3188c390fc58e58765fe129ef4b566e1b0f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16cf33f5551919b50f72a9e1908a8acc903340ffa0807d07129bf8dda445d64b"
    sha256 cellar: :any_skip_relocation, sonoma:        "994e07617590f95137b4263cbe94e447f206a29e8407990f3aa61dadc001bde5"
    sha256 cellar: :any_skip_relocation, ventura:       "7eeb9c86c8531c6d8db94687704e5ddba41fb66b925ddff16242d6a79f92cc1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb031e5cd29ab00b10ed9979a9483256da08b39350505fc935221814ce743bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f69b0e972207579b8a06176252815648a3b6b33c43a468f66c919118bd72462a"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-cyclonedx")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
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
