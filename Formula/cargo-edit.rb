class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.9.1.tar.gz"
  sha256 "bae2a59dcf6110fe0c8bf8562e58d550b2b3b3a02e89b233af5a3be12d41cdf0"
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
      EOS

      system bin/"cargo-add", "add", "clap@2", "serde"
      system bin/"cargo-add", "add", "-D", "just@0.8.3"
      manifest = (crate/"Cargo.toml").read

      assert_match 'clap = "2"', manifest
      assert_match(/serde = "\d+(?:\.\d+)+"/, manifest)
      assert_match 'just = "0.8.3"', manifest

      system bin/"cargo-rm", "rm", "serde"
      manifest = (crate/"Cargo.toml").read

      refute_match(/serde/, manifest)
    end
  end
end
