class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.142.tar.gz"
  sha256 "d2e276461a597b362361756cb13fa491088db56b05c53240fab050f0b140f6af"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "327b02c014e3a2dac69ec3520ea0b58e0c71bfad72a910210f0992a10f09cb97"
    sha256 cellar: :any, arm64_tahoe:       "f8af13c47cec30491115917ac591c57653b39c6068e58b77bdee6e0f30a81439"
    sha256 cellar: :any, arm64_sequoia:     "4710df689d883a65a1cf1574a4a723cebd07235e5e649d8a0552dc751c30eda9"
    sha256 cellar: :any, arm64_linux:       "aa450980eb9e2e3b304d6cf765b5fb209eee95cf9e1f8b7f6fcad9b327fea62a"
    sha256 cellar: :any, x86_64_linux:      "9b094cd3b7ad975e7c60685e90af0922b12afc394a2eac01fc5da8cbd2d338e1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli", features: "dbx-mcp/os-keyring")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end
