class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https://github.com/mikedilger/gossip"
  url "https://github.com/mikedilger/gossip.git",
      tag:      "v0.14.0",
      revision: "53ba02c672e1f2e14da1df11a0fc43fcf19d2526"
  license "MIT"
  head "https://github.com/mikedilger/gossip.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "126dfcfcd86d26541762b3f92bc793f597470af063754ac432508117308dd98a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "149f794ee3f3cfef1fa14d623a2226a3e3337b89ec1f8842bbfeb32dac95f94c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2023c9f221692ab40815523335059e2a729f689127ad17807f2bb171d511b33e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a98a979bea6af255877d7dc14d459232e62c883c4cf497040bfbe06e6f7e72d9"
    sha256 cellar: :any,                 arm64_linux:       "265480daa549850deba4a81e691f44b27692de488a0128fc5728022ed2bdeebb"
    sha256 cellar: :any,                 x86_64_linux:      "110c089e30a00d1487de46516dd9de5a8a00e3f4359e6b7ff459fc1971fbd85d"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libxkbcommon"
    depends_on "mesa"
  end

  def install
    odie "Remove `rust-lightning` source replacement!" if build.stable? && version > "0.14.0"
    # `nostr-types` pins a `rust-lightning` fork whose repository was removed, so
    # point the identical commit at upstream. Upstream gossip dropped the fork in
    # https://github.com/mikedilger/gossip/commit/541c7ae0d3fd4b62af9d86a46a164a16f4b96cb2
    (buildpath/".cargo/config.toml").append_lines <<~TOML
      [source."git+https://github.com/mikedilger/rust-lightning?rev=7a62cb4106d449bc4d1724920b73918d501bb3a9"]
      git = "https://github.com/mikedilger/rust-lightning"
      rev = "7a62cb4106d449bc4d1724920b73918d501bb3a9"
      replace-with = "rust-lightning-upstream"

      [source.rust-lightning-upstream]
      git = "https://github.com/lightningdevkit/rust-lightning"
      rev = "7a62cb4106d449bc4d1724920b73918d501bb3a9"
    TOML

    ENV.append_to_rustflags "--cfg tokio_unstable"
    system "cargo", "install", *std_cargo_args(path: "gossip-bin", features: "lang-cjk")
  end

  test do
    mkdir_p testpath/"Library/Application Support" # for macos
    mkdir_p testpath/".local/share" # for linux
    json = <<~JSON
      {
        "id": "b9fead6eef87d8400cbc1a5621600b360438affb9760a6a043cc0bddea21dab6",
        "kind": 1,
        "pubkey": "82341f882b6eabcd2ba7f1ef90aad961cf074af15b9ef44a09f9d2a8fbfbe6a2",
        "created_at": 1676161639,
        "content": "this is going to work",
        "tags": [],
        "sig": "76d19889a803236165a290fa8f3cf5365af8977ee1e002afcfd37063d1355fc755d0293d27ba0ec1c2468acfaf95b7e950e57df275bb32d7a4a3136f8862d2b7"
      }
    JSON
    assert_match "Valid event", shell_output("#{bin}/gossip verify_json '#{json}'")
  end
end
