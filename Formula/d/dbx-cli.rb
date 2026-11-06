class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.140.tar.gz"
  sha256 "254f16947e1deaedcf9929633c28d56677614bfb568612c569b2e32783fd7f49"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "07a2ce790cbe3f91f9857d784a359717874c943959b07683da044aa137424763"
    sha256 cellar: :any, arm64_tahoe:       "48dfb8fcb6d7585fc451046f3f68fab7e90c16d56f622cdfbee94b58cdd300ae"
    sha256 cellar: :any, arm64_sequoia:     "1c05361c2471e308bfbf31d1b23e55ffd21919a455729f5d59692238eb04a1ef"
    sha256 cellar: :any, arm64_linux:       "d1ef216cf3777d279d96f886e08f8d317aa971dae341e08edcd10c0cbff9af91"
    sha256 cellar: :any, x86_64_linux:      "0514e36d46fe1f2c402e2ae511e65ad54cd06c49b9e15def4e51e23317369705"
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
