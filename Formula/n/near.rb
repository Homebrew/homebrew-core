class Near < Formula
  desc "Human-friendly console utility for interacting with NEAR Protocol"
  homepage "https://near.cli.rs"
  url "https://github.com/near/near-cli-rs/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "2e2b9b9c98fc511153c4486725b92e0dbc12ca0ca1cd3df76e18cb10ddf72059"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "83bbaed669c5a0e155c5851c7b516809822e1ea27154d0a4742003c1c870ce8b"
    sha256 cellar: :any, arm64_tahoe:       "178dd4839610bc387d19951b7759788b2e549ae683246fc91e489f9a7610dac5"
    sha256 cellar: :any, arm64_sequoia:     "dbe062c2696b4e9f283c0069682a49faf493e1e538d347d217449b7fac5516d2"
    sha256 cellar: :any, arm64_linux:       "f8c13f377ed76dee16069d21c9063f33a86beb92d4a5a5eb2db7d8cd9942038c"
    sha256 cellar: :any, x86_64_linux:      "340f0b1a9aaffe64c0abe1494020d92c6e44e5571d14cc012c6bf115796e982a"
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
