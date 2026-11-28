class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.22.2.tar.gz"
  sha256 "ac56e12dfab673dcbf4f219a1f49ea8ed2165a98db6e7227a8bda9f221a755e6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    manifest_sha256 "46d74a01f9171ec075569242611e600d2f7af269ba0858cb78915929c7716faf"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "53ec72e28ddf36aaceec1c0735d446e39e709f36582bd6d007021abb700d1fdc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64deb26d084270226a8d3e0bc0e730f2660284623c4b28a3192ed5d3e0bdae4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8bbdd3549342d586acb14e0cd8fcba5ed645ed655bd247b38de65cebe1fc3b36"
    sha256 cellar: :any,                 arm64_linux:       "54cf7ed08ae327f716326d5beb9abae710299479b96918c66a596bd4b015fdf6"
    sha256 cellar: :any,                 x86_64_linux:      "42209ff7a987b094ccd7a6437ef466210d7f614764320ac927020c891b42c129"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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
