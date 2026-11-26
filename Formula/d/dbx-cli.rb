class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.146.tar.gz"
  sha256 "de090e5b671b2cb083b958cfdd83ed50783ae3b849fa188c988dee399517edaa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "ef5c68beff8ed9eb1b7b8389f526b479c952546984dd5cc068d0fe61792b3b20"
    sha256 cellar: :any, arm64_golden_gate: "00f8fcadca7301015dae0edfa3ee88e3ceeba8515b900449e68a2a45e59c9525"
    sha256 cellar: :any, arm64_tahoe:       "b48e5b6ae0903aacf39b98c4129717944ddf5aa7ef6f1feebab85782a23df6c1"
    sha256 cellar: :any, arm64_sequoia:     "9ca18d584a7bfe413ad23b46c4a58b2b09782070cbccbc497097cf14c64dca71"
    sha256 cellar: :any, arm64_linux:       "bd76956f1bca4fc7a85385c12a17966d72a651c2da96ce91b791e379228d64ce"
    sha256 cellar: :any, x86_64_linux:      "f42f08be07c1ebafe5f99be9a8f171775046eb27c7ea831cea24eaf57187bcdc"
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
