class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.143.tar.gz"
  sha256 "72d88573fa6ccdc8f797dee78b2c70e55afbb44e4a4b181c82edead2b5c9220d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c5e9065bfb7b921e6d586cf60150ea6945d94ebf48cbde072025a9a8eb2f342d"
    sha256 cellar: :any, arm64_tahoe:       "a875ee276887b231a1a0a820548b08b53a9b079e348bd0e47203188abc3b5702"
    sha256 cellar: :any, arm64_sequoia:     "4222d5f931a7a873e5a449c3d9bd9848060b2998dfe4d596580a6e21dd5c21df"
    sha256 cellar: :any, arm64_linux:       "4853d69d11ca6b57adfa6ee81cf01ac84b5c681dae39eeab4670128d50d223b8"
    sha256 cellar: :any, x86_64_linux:      "1bf0cddfec71277958861acbbbc5c6913a2e5dacf5e28e4b1eb56d49cca235ea"
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
