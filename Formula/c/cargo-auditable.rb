class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https://github.com/rust-secure-code/cargo-auditable"
  url "https://github.com/rust-secure-code/cargo-auditable/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "07641dab34429b7d31ee29bd4f0b426fa486e0be81fce2234d5936d0ba240ee8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-secure-code/cargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "011083c3216ae803425418622996fdf56d6a4980ea9f4bd58f95a99f1fa45545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "249dc6cc3871a65ba5495113f07aaf93678f1b7f5a1a111346a58247e9a0c49a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50b0446cbb2238d6b8af7cdbe25181603fb4c2038c34b7b1cdf5a9e9728a1797"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a5be4751c172d07db6cf2d9ccb595ebfce44fe9c36791d4267ae66e236a2b3d"
    sha256 cellar: :any_skip_relocation, ventura:       "faacb064be243871bbfd6ea717347d61742d790d4277f40707fdcfc47d72b682"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "869f19acaf0d3f4ec49c0e34ab32328bbe8b2b38d34fde20a71698deae48bd8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "965e1d851e9dccf7b695a28e732ddb5778709f2a6c402de961387ac656963ab0"
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
