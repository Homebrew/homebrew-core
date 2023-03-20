class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.13.7.tar.gz"
  sha256 "61c9d20baf7b941713cc3b2e83ca2233b39d6efaa4ed11abd73a12839096ff65"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "793518168925844a18e4f8753d6fd7ac54b042a655c33202a4caad3153c84292"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71fd15496031c3a9ba6725f223d49549f8e4b5eea1a8f5b593d645bc44483cd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6aec68abe45a0ede27cd780219f1cd0f55f257ba3ab002a239a63d01285378f9"
    sha256 cellar: :any_skip_relocation, ventura:        "2b5be9883ebb275f902c124435734f1f13cefc6413012fb4d4bed0e9abaac4d3"
    sha256 cellar: :any_skip_relocation, monterey:       "9f4b291a1e9994eb073d3e5da977d6d52be979915acf31355814c445ed07dad8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b02b12819461aedf17d271c54b8b09d1e6f99cc4f0f74a30dc5daae39a73917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b21549d8e6fa598e44767953d050c910ecf13f59af93b36f1b7beda8a612193e"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo deny check 2>&1", 1)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end
