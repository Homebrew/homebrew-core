class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.18.4.tar.gz"
  sha256 "cd093a71d383988252428ebc08ee83f9db204e95074138264f9c8bd5fa06369a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c1b06403a2b9c1e6007e5f89f4be5156f5742da775a1c2cf7b3a57806041d97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e0eb8a678a77bd52d19aedd2380d9bc67dc6e74f05a051dc1411bddb07d08a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd56950cb034d5262a33f91e90930401f76ac520fd26923283b21cb71ea9fe5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "531a170befab28df09df5a9bbba4a049209a7985bbf0ab549fc39a05622a0d8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6a1e32b79e97e896e1103725e9b4136b0f89e70dc34e9d73a11a8120e7f9e33"
    sha256 cellar: :any_skip_relocation, ventura:       "3d724320f5b1e34ae2a862ad5505876f6ccd16686ae39f503aef02855ae867d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecc5071f3e441b1f537d943e7aa350e66af1fc11fd761f5f42e77d473c8b4e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a05cdc9d8af08934616caaa18dd80f6a42e26ae4ab30b8260f14b830b136e75"
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
      (crate/"src/main.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
      TOML

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end
