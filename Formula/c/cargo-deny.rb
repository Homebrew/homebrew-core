class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.19.9.tar.gz"
  sha256 "75d2a77a45253dfc2636c979fbb0fabf1ae30500266e00ed53d56442499525d2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4962ec307f41e1c2a88660db75a8266ca9c095c08ec0736e197a4968077f775"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "434d3ee26100851788403ede395ce89a6dc934299b8b4c16df2e9b8771c26962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccf1ede358508b0f2940e7cfd240ee644688ef1770b995d61cffb36a73e0ef80"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7db800a95db18c59c72cf4e5c8721c06d54c763db0bcb882fc69cd6b1f1c95e"
    sha256 cellar: :any,                 arm64_linux:   "1e22c8739793c920e827c8394804e81df99fbd2e1e284db2e897bfb9cf84baa0"
    sha256 cellar: :any,                 x86_64_linux:  "76a3a4849809e4c75dad07194711c7ec0ee3211222fa6b828706aee5d6877fbd"
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
