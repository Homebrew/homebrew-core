class Near < Formula
  desc "Human-friendly console utility for interacting with NEAR Protocol"
  homepage "https://near.cli.rs"
  url "https://github.com/near/near-cli-rs/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "f21d6cfb7261548915e226aec99d04e8ee810a6f831ca6b37c90e22baf02016c"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "95ec8579bb167e2049aabe2c913993009b5972b591c00534c1d0b09fbf9aeaca"
    sha256 cellar: :any, arm64_tahoe:       "12c130f9c1e48fdc3c44479676738281e12992c4ad30f02e3cfb4555f7098299"
    sha256 cellar: :any, arm64_sequoia:     "552d89071903b66ed2b8570b4e33b896801a63b19d6d754565b4b7d0de05aa59"
    sha256 cellar: :any, arm64_linux:       "eb5e9a886952745155b310a1710a1b562f486b04c1f280d46a7fdf4f0c6e7fc4"
    sha256 cellar: :any, x86_64_linux:      "70dfa045e7cd618df165cf0ba741fe2af3aa7abd95f9f3a6aed619730a8e0140"
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
