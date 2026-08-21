class Near < Formula
  desc "Human-friendly console utility for interacting with NEAR Protocol"
  homepage "https://near.cli.rs"
  url "https://github.com/near/near-cli-rs/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "138ad2a38bf63a989529d691144be150db9bf353fbef91b958c638c86af124d4"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fab69bd805ac31da19df721b959fbe51a9ba2bbb55a031f3ae73e4afb3c34320"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08a8bd73c43569343342e9714d6895c5f901a4478237e57103038e970a9af7b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0531c11425b81f375debf75cfa065a178a0955a00661af0d66bb73f92f3b7613"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7bfeebf1f8fa7f9632c428866c4d52fd12fa67e94a4a2b52397bd9e0c7a9039"
    sha256 cellar: :any,                 arm64_linux:   "0fec8691ffec4d13b545892bb14865400016f3e0a1b73fafeb52884c2fa478e1"
    sha256 cellar: :any,                 x86_64_linux:  "8c0bf94118783cd7cc5d3fa0271e391029b626ebe0a8425d972657a6d9805975"
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
