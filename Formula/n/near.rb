class Near < Formula
  desc "Human-friendly console utility for interacting with NEAR Protocol"
  homepage "https://near.cli.rs"
  url "https://github.com/near/near-cli-rs/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "57e1249856b70b3cf6562becc618602d3c1a1f3aca98e7d909f33dfdb85e5439"
  license any_of: ["MIT", "Apache-2.0"]
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1918565d359e5641c05739646acc1dbdae6f55218cf9beeac967fa2a2b7afc71"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1bedd2e7f3bcf98bd2cde565aa3bc3553646e213309a23b428e3076524655688"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f9ec90712f734adf366edd9e4790a998b1823ee92f80d4ba747515b4536aa01"
    sha256 cellar: :any,                 arm64_linux:       "39ba64c108e18433007f033d93f60b50068769fc5bf4400cd8321a2c8dc0e1ae"
    sha256 cellar: :any,                 x86_64_linux:      "8dd188d6c42de851e24b0ddde97c74cd6802c6f0dc95fe9fdf0706d6191b6add"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "systemd"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    features = "ledger,ledger-ble,inspect_contract,verify_contract"
    system "cargo", "install", "--no-default-features", *std_cargo_args(features:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/near --version")
    connections = shell_output("#{bin}/near config show-connections 2>&1")
    assert_match "[network_connection.mainnet]", connections
    assert_match "[network_connection.testnet]", connections
  end
end
