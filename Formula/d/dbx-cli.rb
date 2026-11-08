class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.141.tar.gz"
  sha256 "f253e292025620cd61d0eabf4351593d72e3550efc94a531f6ef0ed8aae9ea1a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e0ac65a4cceb87f0e699ba74bea8ab9ec3b483e6d2d4796125d2453826176ab3"
    sha256 cellar: :any, arm64_tahoe:       "86d7cc2ab85846709dc9c9ad17848cfe370c2458fe5367a22f5078327f74f1f6"
    sha256 cellar: :any, arm64_sequoia:     "df5eb3d77821c72a1c4c5a58cbc54fbbf04a914faa147e651a1ab5230cfe279d"
    sha256 cellar: :any, arm64_linux:       "0b8d4833998829c25afa2454e72af7ba5b1c186f5529257b6da5c4f62085a833"
    sha256 cellar: :any, x86_64_linux:      "e75bc2724536df65ec220d04cd8e25995aacf421004601326b7a4e4fd2245916"
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
