class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "8f94d5fd27ec8297728a12172c9ec14ecb55c8b1331049ecc04de3c101f4485f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d6aa35a5b8f210ab6231054e6a852dea374a7265515861e93f7271e7f9b1bf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbf2296c9b452c13069967e92507d2552a1b6acfdb701e9bae05d867e1b2af0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33f4619f40d80eccddbefa65d3c18e5ff3ba014a16e61069bed47b1f489bbe03"
    sha256 cellar: :any_skip_relocation, sonoma:        "5982e547b66d413935c4f4f1b4653ffac3f9c0be7d241a65cf77e155dd285ddb"
    sha256 cellar: :any_skip_relocation, ventura:       "31c7d7b4794cb9d4b156bcf20a1521b611fe721e76705ed52322851aea096470"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f55d7c8d26d94e286720f6e4db4cd0912e07e5e6f65957f284e9b513a163fdf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdf2bed1dbf1d0bd008abd5515698cf1e9cf4f4acda2fc9fda912ddca2ba63e9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "2"
      TOML

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system "cargo", "rm", "clap"
      refute_match("clap", (crate/"Cargo.toml").read)
    end
  end
end
