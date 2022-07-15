class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.10.0.tar.gz"
  sha256 "fedc4200095d221935d4716fd8f4104e8607e5f4618c6c52580fef404e4d63b7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e9c27e9d667528d19e4e3b3e8937a8483c5332919c7d2520807d8992824c37f3"
    sha256 cellar: :any,                 arm64_big_sur:  "2fbd2de8afe7c95ad02f96d5a46fba6c441fcb0ba7466293773cbdb7731e01bd"
    sha256 cellar: :any,                 monterey:       "8094fcd189b40222a08aa9b43310345a6f428b88ce5cdb0e869c46854c7def2e"
    sha256 cellar: :any,                 big_sur:        "8ec4f37fd37bcd420e20e3feb203ac86bd2afa50d0285242e084964db94c6e2a"
    sha256 cellar: :any,                 catalina:       "a69b391438f6d6927906cbb3c9146ffe6823d3c93df17ee3a68b3fd08bcfe801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9e585a3818bf0a23b14bac6e068b408444c8a1c5a07a82a326023c963e6e0ca"
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
