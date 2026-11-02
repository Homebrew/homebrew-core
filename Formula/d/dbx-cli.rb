class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.137.tar.gz"
  sha256 "894b2714af4b008cff38bfbe97ee8fd2bb8c1f8ff032124cbc5e45902cfecb73"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c01bf051037a32f7604b51dc588b20ea0ef2abe2c1ad457b4c8f8133f0be5df9"
    sha256 cellar: :any, arm64_tahoe:       "7ba74a65a642a37ceb8f4e2a01eda39d9ab27abee4a3e83e548ce9a0cd056fec"
    sha256 cellar: :any, arm64_sequoia:     "3db3d4e6242f4d1b944fcd91dba9356e3b2f15ad412525636b837992e924a7e0"
    sha256 cellar: :any, arm64_linux:       "7be736702d71adb647f2c884d072b9ff5e905d5a902667ee7ea033380b6d104d"
    sha256 cellar: :any, x86_64_linux:      "8066fd669aad1a13ed3cd73d02fe18c0526394da0eafe3f672a5255dbc0a87a7"
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
