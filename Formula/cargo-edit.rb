class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.10.4.tar.gz"
  sha256 "f4a6d94b48b27b6db7bd27d6091f0c9aeddf224c8a8dfe31133750530f096890"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "79e2ff6224833ed590141a3b8018d1a0862bc06b7df771cde8de0199ca02da1c"
    sha256 cellar: :any,                 arm64_big_sur:  "ff9ce02ee3bc5f17e81557d224dac53305c10f6c62572d6f23d77b3abc888182"
    sha256 cellar: :any,                 monterey:       "aa5daafbf92df46d9b2dc178ef9c956edb5826a12f72c45dca96f6dc7d93955d"
    sha256 cellar: :any,                 big_sur:        "0f52dc62ab1d579f8eeb86c7f96f0fb71eda72fba5e4a1e134faf2a399ae7c38"
    sha256 cellar: :any,                 catalina:       "54d7f86bd793147808af3894fe1d6f6ec514ec1c6bff780894b32a57b3515f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67769ae39556f7addfcc155c0ffd574af5167a9999e73496a6b97344829ff5c3"
  end

  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "2"
      EOS

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system bin/"cargo-rm", "rm", "clap"
      refute_match(/clap/, (crate/"Cargo.toml").read)
    end
  end
end
