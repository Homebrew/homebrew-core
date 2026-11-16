class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.144.tar.gz"
  sha256 "68d2a7061d5bb7e1954211015632a13782e5ab56013cb90ff9af7b73a85b17c4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cee887687176b74bbebdcd11b80603cb84d791dae2e35d3cb9902b5b79a2f1c8"
    sha256 cellar: :any, arm64_tahoe:       "fbcfc6e8ebc4eb196f48d3aebb4110a068adcb15fdb4456755d37e89a9806be0"
    sha256 cellar: :any, arm64_sequoia:     "d547cc8adb6b6c03f4daffd4b3e6c002fb6c320178b7d94bb5718b6618e069be"
    sha256 cellar: :any, arm64_linux:       "40016bca7afc074bd107ec6ea44bea0ad5b69a866085becebe96282009182cea"
    sha256 cellar: :any, x86_64_linux:      "af4721d118c3a15bf99ac9359cf0c9a5bd1ae88ac14bf836d1f218dd8737c71b"
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
