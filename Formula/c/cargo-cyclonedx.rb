class CargoCyclonedx < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Rust (Cargo) projects"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-rust-cargo/archive/refs/tags/cargo-cyclonedx-0.5.9.tar.gz"
  sha256 "36f0dbdd203424cdcb2d73d71093a2795494c776ca5ff9039d5002e4b7785da7"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-rust-cargo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cargo-cyclonedx[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce17165c9bee2938de66837ca8e86a6a5f87355da84728f3b49420956eada0d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3415a06c50578e57b1a6baf9a1a4e470713b92904b1df7921e69a392c6bf602f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0314789edaac1408c04ba42f058ea5e9ae38ee88b4913b4fb7c2db0b6f2b19d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c640eb162b69d7fc4833cf18fefbdf178268bb952b91c990b97cfc9467b91541"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c616c3e41fb4e29e25bc0ed4247a731a61d9fd8cf3d0a164ccac849f203b798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0db5dbbdc52e869cbb5a075a40150bdf54e5a3862741fd55b95c11aedbe88fab"
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
