class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.138.tar.gz"
  sha256 "25b8b0952032cafe99ec1fb0217b948d4117f99594354fff13987c7ec75f2425"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9adc172892a5d83f9ea1cfdb5124641ba327d115e844f0b23ebd3116f290545a"
    sha256 cellar: :any, arm64_tahoe:       "c5c70934f3e18948973d07f6bdd5e04cec6ff54cf12c39a431415653fc524755"
    sha256 cellar: :any, arm64_sequoia:     "42f53505606ca3e85f4b3479bca2eff0bf9735f2fa3d9409b70e74049c0f6dee"
    sha256 cellar: :any, arm64_linux:       "47e28edab168833582a45f00855e205e06b3930eca4afdbdcf945fefc812e0ba"
    sha256 cellar: :any, x86_64_linux:      "7a7cb4c2e8d6a5e552d5d7c740f0c6e1e92c6cbe844b00df368fc3364cb8722b"
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
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
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
