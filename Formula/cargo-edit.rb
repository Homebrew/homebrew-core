class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.8.0.tar.gz"
  sha256 "4a08e914c17204cb3ab303b62362ca30d44cf457b3b1d7bde117b8ab4cb2fa64"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "eb04c951480fec71b299c9cdda64fb0a3e7fc84a349fb185b7a193116d74ee4a"
    sha256 cellar: :any, big_sur:       "226eade3e8d1b9cd385abd5e37d659314f794a9ecdea5a71e88250ee8befaed8"
    sha256 cellar: :any, catalina:      "eaf1bf3dc8d93b52035ba8f349d5e143742f5cf912be73a67550f0eb1b409803"
    sha256 cellar: :any, mojave:        "30e4b1ed5ddf69752deebec4480aab5aad32fe9da351324b67e42c00024c413d"
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
