class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v8.3.3.tar.gz"
  sha256 "f0e693996e08bf3dc738bc96be76751140906b8e0cb3ac0215e5a3a95ce01c0c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6616a49c8c67487a8897a8de4004a3e81ee36ff01c18486d4b22bc2d723a7c64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d17e60557e24a793fb98b82073ee59382227dc1b6f9253235504be20c9ddd30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "482d0d0f52be6ea27302eb5a57665dd206c477aab4a1bc3e4b01175a69964a2e"
    sha256 cellar: :any,                 arm64_linux:       "27d80a84cb988f89a8b9629c9998e62dac49b30d941274fd1981613d00e862be"
    sha256 cellar: :any,                 x86_64_linux:      "19a64910051b64d22511941c5b7423e9cfd617bcdbf5a0d5f7ad6cdbea86d7cd"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zlib-ng-compat"
  end

  resource "specs" do
    url "https://raw.githubusercontent.com/ethereum/eth2.0-specs/v0.12.1/deposit_contract/contracts/validator_registration.json"
    sha256 "66c9407b5c249a483c4ee6bf0269847c19a3a8c55c1888981f08be5acb04c1af"

    livecheck do
      url "https://raw.githubusercontent.com/sigp/lighthouse/refs/tags/v#{LATEST_VERSION}/common/deposit_contract/build.rs"
      regex(/const TAG: &str = "v(\d+(:?\.\d+)+)";/)
    end
  end

  resource "deposit-contract" do
    url "https://raw.githubusercontent.com/sigp/unsafe-eth2-deposit-contract/v0.9.2.1/unsafe_validator_registration.json"
    sha256 "69e4de1d14f742dc4145234c0884c85a6c7cf6f1ada31d8ecd27dff2f67e4586"

    livecheck do
      url "https://raw.githubusercontent.com/sigp/lighthouse/refs/tags/v#{LATEST_VERSION}/common/deposit_contract/build.rs"
      regex(/const UNSAFE_TAG: &str = "v(\d+(:?\.\d+)+)";/)
    end
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    resources.each { |r| r.stage buildpath/"resources" }

    ENV["PROTOC_NO_VENDOR"] = "1"
    ENV["LIGHTHOUSE_DEPOSIT_CONTRACT_SPEC_URL"] = "file://#{buildpath}/resources/validator_registration.json"
    ENV["LIGHTHOUSE_DEPOSIT_CONTRACT_TESTNET_URL"] ="file://#{buildpath}/resources/unsafe_validator_registration.json"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "lighthouse")
  end

  test do
    assert_match "Lighthouse", shell_output("#{bin}/lighthouse --version")

    (testpath/"jwt.hex").write <<~EOS
      d6a1572e2859ba87a707212f0cc9170f744849b08d7456fe86492cbf93807092
    EOS

    http_port = free_port
    args = [
      "--execution-endpoint", "http://localhost:8551",
      "--execution-jwt", "jwt.hex",
      "--allow-insecure-genesis-sync", "--ignore-ws-check", "--http",
      "--http-port=#{http_port}", "--port=#{free_port}"
    ]
    spawn bin/"lighthouse", "beacon_node", *args
    sleep 18

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
