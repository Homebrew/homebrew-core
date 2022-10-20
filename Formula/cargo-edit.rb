class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.11.5.tar.gz"
  sha256 "94a05e61af26163a82d529639a3c3859c3f2e0ffb94260fca0d5856f5ab62021"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9257543d88c9647f8f8b71fa0a54312daf71ff6487a14ef6a751d27fdae8003c"
    sha256 cellar: :any,                 arm64_big_sur:  "15640b9cd0cb81c6f7ffd6fd935f237b58c66488278ad77790463ba587e9f1a7"
    sha256 cellar: :any,                 monterey:       "5c93fb1c93592fb121d42419393007d0788ecfbb30a34717bd86a91f0b983e11"
    sha256 cellar: :any,                 big_sur:        "508a1b30089a50de7333f933623727d3253a8eb6b7ca7cfc9cc402d3280c4bb1"
    sha256 cellar: :any,                 catalina:       "345142f6463dacedaa81db30eb3bf6c5c4d44926f918249b40352175d9a6fdec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d0ad9ba7697cb9ccc8ed5a82d1402fa6f7cc25fe65862f1f9c947236117e5cf"
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
