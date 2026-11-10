class KrakenCli < Formula
  desc "Trade and manage a Kraken account from the terminal"
  homepage "https://github.com/krakenfx/kraken-cli"
  url "https://github.com/krakenfx/kraken-cli/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "dbf0f27b7a264297c67e260c5a0da0fc54bd8aaf3e37a6f4ad064d8416b26b36"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    # Match the upstream release's optional DuckDB recording support.
    system "cargo", "install", *std_cargo_args(path: "crates/kraken-cli", features: ["record-duckdb"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kraken --version")
    assert_match "kraken-mcp", shell_output("#{bin}/kraken-mcp --help")
    assert_match "kraken-shell", shell_output("#{bin}/kraken-shell --help")
  end
end
