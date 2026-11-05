class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.139.tar.gz"
  sha256 "cfeb71499021231d7332474b05a07c71160fababb5393cd8789712473d46fad6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "876a3742b8a21195e0c0056ecdb84044f2c95d8a3eab6595d9ba78f4914b58ea"
    sha256 cellar: :any, arm64_tahoe:       "2471d7c8e39a373a1a8ad39c6672a0cc07376f8bf0117cda61eea2f0c69af38a"
    sha256 cellar: :any, arm64_sequoia:     "e42a394082e340e07da1e006b4b616d711af3218dc5562fb941f24ff5b18d5b5"
    sha256 cellar: :any, arm64_linux:       "d536d1ae823a38e68bb629f149855f70ba2511bd442efbe27ef95d0695cd52a4"
    sha256 cellar: :any, x86_64_linux:      "78ab2e41275133db9f76b94329c71bbea65134a82fcd2ee14a0b6943b6375e73"
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
