class CargoFeaturesManager < Formula
  desc "TUI like cli tool to manage the features of your rust-project dependencies"
  homepage "https://github.com/ToBinio/cargo-features-manager"
  url "https://github.com/ToBinio/cargo-features-manager/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "f0a0894a4bc5de422b6ac1cae8a28ff605715fedae14ed3a44dea0eeb734f91d"
  license "MIT"
  head "https://github.com/ToBinio/cargo-features-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94ce47b67a56b1faa492c358ac28983b61ddbadb4ad0d6dd43271ff2a47c2c66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e1846ea47e4dd663b7cc0265376036d919fcabe84af45c232a62a81a5391664"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9827f2046ce1e5020c57e36fc760718b1f0c7f4e2719d8eed672dd454b0fdb37"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b329a740b87964ff97724159cc0ba7c3a3fea0decdfd493bedf7f02a7c9c64c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8b51411bdcdd331629eda6404f0e3d0befce1402940636168e5bddeccf0fc03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40e2a29fa648d6c5c128e572134933dee66a4353709ff799757b81bf875b2a07"
  end

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
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
        bear = "0.2"
      TOML

      (crate/"lib.rs").write "fn main() {}"

      output = shell_output("cargo features prune")

      assert_includes(output, "Creating temporary project...")
      assert_includes(output, "workspace [1]")
      assert_includes(output, "libc [0/1]")
    end
  end
end
