class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.19.0.tar.gz"
  sha256 "0d4d6972b9ab8ba939a7d26f5c5fd0227dc9d4e8579f6baec6f4831f50155a1d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95107dd182252ad629558292d3b32470809154f25154ef6c307e1450b5953cd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3edce97742a97b3523c737ea8ac74c675a61246706770de32d4d8d7fa20623c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56ddf4a229ce19e1b0b6857e8b65cae0c751ef3259c6ac5d2174c46466388b02"
    sha256 cellar: :any_skip_relocation, sonoma:        "e82bb74957324383560f1e89fc07add19141c2c9f30b55a96c9f6dd8d8885f2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc2324f01b058b4532d935f752014436b7ececc979914d4afb7e74af6a621cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "151b560a8a62a72480a81b95b2fdef54e6533c4a59064674260e08961e74dad1"
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
