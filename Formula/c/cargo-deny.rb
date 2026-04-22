class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.19.4.tar.gz"
  sha256 "f69e6472a02c6059c2813170d9767ff7305862c82d7b6a09dea8cb1e67648b73"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc0c803c039caeee2c9f16bac27e68bc79178ecb25fac055f9df7b2d4adef651"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "097af2f2bbeb120fd6eec33987592638244af1a7ae24f391a5ce141d4cb526ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec57a258d3b169d97946d8e85242ba0393858fa5efbf41444861d3308b27fdb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "aad736a6a94f62d4351280478a432827eb9ff4be3580b3ed0fa5afe803ead013"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c473796166bf349cf8e353ad84804d6748eb4e09ddbeb053f87e0d91b596afa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77063797877ff97ff37eac06c6701988a166f4d705f4435175e04006aede8218"
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
