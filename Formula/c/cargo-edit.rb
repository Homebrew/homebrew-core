class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/refs/tags/v0.13.6.tar.gz"
  sha256 "325975345522decc9089635bb19b61c30942254a34b570925049fb56672d400d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1a90ec96d74925779b5cc9ed1e9e4075ad9b6c2f9e6cfd82584070713e4b7bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39cf574d3cb563c13d7f2b8316233841d2a1a2d6b966a1bd426aaacb2c508ee8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb65f2789b5acccd57238887df0b7697ce19f972e8a3110a91968e1645cf7064"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4ea244762719cbbc605f752526c072a4366b386eb8bc42d7c6cc5be81345ed7"
    sha256 cellar: :any_skip_relocation, ventura:       "838b11bfba83732ed849baa9b12881f3853498a91ecf3231f19a9a08b1ec1a14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e3416d3b3b736cb8bb936334b05847ad440279f786a325c17aad5f9ec4c02b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e5f730df10ffae88ebe4e5289c91bb19f9d85d34b32857f0cbc0a29d4f480c6"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

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
