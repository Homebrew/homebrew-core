class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.13.9.tar.gz"
  sha256 "b26d8f984e00ddf96766e25781d6b296ff7a571f2c3730a607bfde24062b8adb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca6b65a601087b17a9f2a82a9789d627c6fc2b1c9d6a16cb9d58d6bfa8e17f91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8496fdf12ca641da4c493e167446da07ab515393367bd69995302f21bcf503c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89c5701013d98a9741b2e196ca4d92b84bb4aa80f1e69a782e8d78b0905f2b58"
    sha256 cellar: :any_skip_relocation, ventura:        "ad758ac4859764e878b36aecdac10d5576002cef13aa8e3fa230516dc86e98d6"
    sha256 cellar: :any_skip_relocation, monterey:       "9843a23134f12167dfb9069c907acbf7f35243a85f86a68b9eb5341f3ced622b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9f318740cca607e2974746e978fbc1600074ed29747b84668ef7c7e7fc8c97b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc554aeb725a5ed4e2de2c98c4b55f3915e84609c8f7b267c6697225cef50049"
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
