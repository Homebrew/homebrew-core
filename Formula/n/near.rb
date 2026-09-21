class Near < Formula
  desc "Human-friendly console utility for interacting with NEAR Protocol"
  homepage "https://near.cli.rs"
  url "https://github.com/near/near-cli-rs/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "57e1249856b70b3cf6562becc618602d3c1a1f3aca98e7d909f33dfdb85e5439"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a125af9c0dce89e54ac234428db5244faf8f600cab30bdda9c3761ab2d96de9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "332a038e6b64dc6dc0ccbd7c7b66963efa438586d6992bb89c490c71ec887cbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab6f16759a48ccc1fdd7d64cf24ddfa4d3141dfe8d4ceaa330ef61e0380526e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fa781dd0b819eb09697223139d428292efb99689e01b57cf23fc2a00aaf29c3f"
    sha256 cellar: :any,                 arm64_linux:       "fb8d9ea745c1e2785dc4fdb59a3f171c2fc97cf24b4c6e1574c04143d714d86a"
    sha256 cellar: :any,                 x86_64_linux:      "333aaab37b92dbd710cdef9ce7f8a86a3d50841d1b2f32710f3b29042ba92224"
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
