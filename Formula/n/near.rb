class Near < Formula
  desc "Human-friendly console utility for interacting with NEAR Protocol"
  homepage "https://near.cli.rs"
  url "https://github.com/near/near-cli-rs/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "548ac36f0e3d75d83a0dd1a9a9bbbacda6e52e5c9d1061849ccf74e466e5581e"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1ae48a001114d566e9743bc2f3812b43abc3324287d5095a22e658011721ae97"
    sha256 cellar: :any, arm64_sequoia: "a34b4b4609f7e41f756cb16cebac3ef62517c2710c03fa112f4507913e1fb830"
    sha256 cellar: :any, arm64_sonoma:  "24413dc997293f5220a3a421c3e7dccc0b1c1a269b99f2450ef651adfbb4f503"
    sha256 cellar: :any, sonoma:        "1ca18544d274c39b801b034aaa7909f75010aae85d27d871df21364422783ac0"
    sha256 cellar: :any, arm64_linux:   "348b8a647e622b6d7408ef569a6e57e99927312853e4089389f52a563c12a3d0"
    sha256 cellar: :any, x86_64_linux:  "763973bfc97934dff9fbbcc3a328b70b5dba7274cf7ea50cf8d688bdd3b4b285"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "systemd"
    depends_on "zlib-ng-compat"
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
