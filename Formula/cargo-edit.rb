class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.9.0.tar.gz"
  sha256 "96c231b30339b1a05444c8faa036be84ecbb7f8eaead95c77de9a05f0c190b64"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "978433d5da1a412e5b3a4467497e38cd97b0ec1e822473fccdec8bd60fe38db5"
    sha256 cellar: :any,                 arm64_big_sur:  "2f821457849d5095029c72578adbfb0d970cc930987c0a22a00c9a6a6d4892d1"
    sha256 cellar: :any,                 monterey:       "b40eefdfa805e3f81d9c880628ef77033507c238f638c864187d8ac99483ba3e"
    sha256 cellar: :any,                 big_sur:        "0d61c724c6a67d418f7b8897e8128a9456dcda7b8f12e74c2070743b9f02cd3a"
    sha256 cellar: :any,                 catalina:       "f655140e4972f6989d33d3b57dc8cf3173b1d56a90ef3a34b433a5e4b183fd99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "780b1c90357c97511c16fbb5811650f5475e3a363a8c31db5a86601a3c92672f"
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
