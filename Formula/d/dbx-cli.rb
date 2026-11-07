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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "4c523bd61bbefb1e952a19979897cfe2f9a87a5806ce02575e7765645d341c01"
    sha256 cellar: :any, arm64_tahoe:       "c00c3d4c34801f0c3d656671f257f32ad009b19bb599ebd34be05bf8ab4721d5"
    sha256 cellar: :any, arm64_sequoia:     "2293250405c68f7f2b4fa710cedd081cec00373276ef76702d1851cd695b9760"
    sha256 cellar: :any, arm64_linux:       "328615ab719c25031d7b61fe03b505184dac59642fc057c944058ae103b5d8ec"
    sha256 cellar: :any, x86_64_linux:      "31179727473b4b867615b29b4fc767d0bd14222ce9236682a216d93b739891ef"
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
