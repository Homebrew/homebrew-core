class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.123.tar.gz"
  sha256 "9a83378bb9a62d0ca88a43857c9ed13035cb90285a8e5f68edfe31705ec34175"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4753b36698a902caa028c0f29fd725b178c62fea4e9057b3f1f206c904c8fe5e"
    sha256 cellar: :any, arm64_tahoe:       "3913733b696e6a1dbb0e6cdfc92bc673d3da4ba82bf1f7042e41932c70a3a468"
    sha256 cellar: :any, arm64_sequoia:     "4ebcb88e9011d12c3cf0d40ea4527ad4fdfd4a5118b2ab1786cd6e987ea31333"
    sha256 cellar: :any, arm64_linux:       "600a19c247564dd49043bab0b5d07fdf590d9e5a4781c81b92e1bef1bc255d59"
    sha256 cellar: :any, x86_64_linux:      "aa2171b32350e0cd82e6d5cf8df792da951ca2e3bf8247df8afdbabd378979c0"
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
