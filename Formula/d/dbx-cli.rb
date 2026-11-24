class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.145.tar.gz"
  sha256 "a3be6c6db564f2c031d33e2cb05faf88c7a5c2c5a1908411abf5e72cf90d55fb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "b05779cf9b07143652a47bdca1f76357f3ceaf9040ae7604791ca219fdedeb56"
    sha256 cellar: :any, arm64_golden_gate: "61dcf629d133b93e5ae738fa353dce73b632610e7ce9f323a26b3c9cdb09bb91"
    sha256 cellar: :any, arm64_tahoe:       "1d9c790475bf3dc29cf6348bf53384c22c554d026e31cc44c1e5123a3e6d34b8"
    sha256 cellar: :any, arm64_sequoia:     "0e649061b292bd5f23cb22b17269f53a85e1d4a89f566981ad501b5be39c4130"
    sha256 cellar: :any, arm64_linux:       "d3d949947cd69493611a7ae6afc066eea5549fb7a8508eb4c26c55e0d5380893"
    sha256 cellar: :any, x86_64_linux:      "49051a6ce3e165773d2358ee6dfe840a4180660885ff3b9096ddc46b3d4a64dc"
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
